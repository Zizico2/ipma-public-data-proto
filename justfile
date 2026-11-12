default:
    @just --list

fmt:
    rtk buf format -w
    rtk cargo fmt --manifest-path rust/Cargo.toml

verify:
    rtk buf lint
    rtk buf format --diff --exit-code
    rtk buf build -o /dev/null
    rtk cargo fmt --manifest-path rust/Cargo.toml -- --check
    rtk cargo test --locked --manifest-path rust/Cargo.toml
    rtk cargo clippy --locked --manifest-path rust/Cargo.toml --all-targets -- -D warnings
