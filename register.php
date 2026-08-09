<?php
// Crate - registration page
// This is a traditional PHP form: the browser POSTs directly to this same
// file (no fetch/JSON here), PHP checks the input, and either shows
// errors or logs the new user in. Auth pages stay simple form posts
// rather than going through Vue - there's no benefit to making this
// reactive, and it keeps the security-critical code easy to follow.

require_once __DIR__ . '/includes/auth.php';

// Already logged in? No reason to see the register form again.
// current_user() (not just is_logged_in()) so a stale session left over
// from a deleted account gets cleaned up before we decide to redirect.
if (current_user()) {
    header('Location: index.php');
    exit;
}

$errors = [];
$name = '';
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $passwordConfirm = $_POST['password_confirm'] ?? '';

    // Server-side validation. The form below also has `required` and
    // `minlength` attributes, but those only stop a well-behaved browser -
    // anyone can turn off JavaScript or send a request straight to this
    // file with curl, so the check that actually matters is this one,
    // here in PHP, before anything touches the database.
    if ($name === '') {
        $errors[] = 'Please enter your name.';
    }
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = 'Please enter a valid email address.';
    }
    if (strlen($password) < 8) {
        $errors[] = 'Password must be at least 8 characters.';
    }
    if ($password !== $passwordConfirm) {
        $errors[] = 'Passwords do not match.';
    }

    if (empty($errors)) {
        require_once __DIR__ . '/includes/db.php';

        // email has a UNIQUE constraint in the database too, but checking
        // here first lets us show a friendly message instead of letting
        // a raw database error escape.
        $existsStmt = db()->prepare('SELECT id FROM users WHERE email = :email');
        $existsStmt->execute(['email' => $email]);

        if ($existsStmt->fetch()) {
            $errors[] = 'An account with that email already exists.';
        } else {
            // password_hash() scrambles the password using bcrypt before
            // it ever touches the database. We never store the real
            // password anywhere - only this one-way hash. password_verify()
            // (used in login.php) is the only way to check a password
            // against it, and there's no way to reverse a hash back into
            // the original password.
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

            $insertStmt = db()->prepare(
                'INSERT INTO users (name, email, password) VALUES (:name, :email, :password)'
            );
            $insertStmt->execute([
                'name'     => $name,
                'email'    => $email,
                'password' => $hashedPassword,
            ]);

            // Log the new user in straight away by storing their id in
            // the session. session_regenerate_id() swaps in a fresh
            // session id at the moment someone's login state changes -
            // this stops "session fixation", where an attacker tricks a
            // victim into using a session id the attacker already knows.
            $_SESSION['user_id'] = (int) db()->lastInsertId();
            session_regenerate_id(true);

            header('Location: index.php');
            exit;
        }
    }
}

$pageTitle = SITE_NAME . ' - Register';
require_once __DIR__ . '/includes/header.php';
?>

<h1>Create an account</h1>

<?php if ($errors): ?>
    <ul class="form-errors">
        <?php foreach ($errors as $error): ?>
            <li><?= e($error) ?></li>
        <?php endforeach; ?>
    </ul>
<?php endif; ?>

<form method="post" class="auth-form">
    <label>
        Name
        <input type="text" name="name" value="<?= e($name) ?>" required>
    </label>

    <label>
        Email
        <input type="email" name="email" value="<?= e($email) ?>" required>
    </label>

    <label>
        Password
        <input type="password" name="password" minlength="8" required>
    </label>

    <label>
        Confirm password
        <input type="password" name="password_confirm" minlength="8" required>
    </label>

    <button type="submit">Register</button>
</form>

<p>Already have an account? <a href="login.php">Log in</a>.</p>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
