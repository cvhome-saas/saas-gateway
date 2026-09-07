# The gates CI runs, in order. `step "<name>" <command...>` stops at the first failure. Keep identical to CI.
step "diff is clean of whitespace errors" git diff --check
step "docker build (xcaddy)" docker build -q .
