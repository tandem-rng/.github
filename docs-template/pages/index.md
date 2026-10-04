# PORT

Say in one or two sentences what the port is, which backends it runs on, and that it produces
the stream of the [specification](https://github.com/tandem-rng/spec/blob/main/SPEC.md) bit for
bit.

- [API](api.md): the public interface, its extra interfaces and parallel use.
- [Design](design.md): how the fills and the derived draws work in this port.
- [Tests](tests.md): what the suite checks, where the fixtures come from, and what CI runs.
- [Speed](speed.md): the measured figures, with hardware and method.

## Install

Give the toolchain floor, the build and install commands, how to vendor the code, and any
packaging recipe. Name the pinned upstream commit if the port vendors another repository.

## AI assistance

Keep this paragraph as it is. Add one sentence only if this port differs.

This implementation was written with the help of large language models under human
direction. The design and the specification are human work, as is much of the
Julia implementation. The code is tested bit for bit against every vector of
the specification and against long stream dumps from the Julia implementation,
and every value must match. The output does not depend on who or what wrote the
code.
