# Contributing to tandem-rng

These rules hold for every repository in the organization.

- Open an issue before you start work, so we can agree on the change first.
- Keep the stream bit exact. Every port must return the values of the
  [specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md) and its test vectors.
  A change that alters a draw needs a change to the specification first.
- Derived draws (bounded integers, normals, exponentials) follow Appendix A of the specification
  and must match the cross-port fixtures of tandem-c and tandem-cuda.
- Add a test for each new function. Where another port has the same function, test against
  fixed values from that port. Regenerate fixtures with the repository's tools, never by hand.
- Do not add a dependency without a reason stated in the pull request.
- Give each speed figure its hardware, toolchain and command, measured on an idle machine.
- Keep each pull request to one change, and make sure the suite and CI pass.

By contributing you agree that your work is licensed under the Apache License 2.0, and you
accept the [code of conduct](CODE_OF_CONDUCT.md).
