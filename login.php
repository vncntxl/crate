<?php
// Crate - login page
// Same pattern as register.php: a plain HTML form that POSTs to itself.

require_once __DIR__ . '/includes/auth.php';

if (is_logged_in()) {
    header('Location: index.php');
    exit;
}

$errors = [];
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';

    require_once __DIR__ . '/includes/db.php';

    $stmt = db()->prepare('SELECT id, password FROM users WHERE email = :email');
    $stmt->execute(['email' => $email]);
    $user = $stmt->fetch();

    // password_verify() hashes the password the user just typed using the
    // same algorithm and compares it to the stored hash - it never
    // "un-hashes" anything. We show the exact same error whether the
    // email doesn't exist or the password is wrong on purpose: telling an
    // attacker which one was wrong would help them work out which emails
    // even have accounts.
    if ($user && password_verify($password, $user['password'])) {
        $_SESSION['user_id'] = (int) $user['id'];
        session_regenerate_id(true);

        header('Location: index.php');
        exit;
    }

    $errors[] = 'Incorrect email or password.';
}

$pageTitle = SITE_NAME . ' - Login';
require_once __DIR__ . '/includes/header.php';
?>

<h1>Log in</h1>

<?php if ($errors): ?>
    <ul class="form-errors">
        <?php foreach ($errors as $error): ?>
            <li><?= e($error) ?></li>
        <?php endforeach; ?>
    </ul>
<?php endif; ?>

<form method="post" class="auth-form">
    <label>
        Email
        <input type="email" name="email" value="<?= e($email) ?>" required>
    </label>

    <label>
        Password
        <input type="password" name="password" required>
    </label>

    <button type="submit">Log in</button>
</form>

<p>Don't have an account? <a href="register.php">Register</a>.</p>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
