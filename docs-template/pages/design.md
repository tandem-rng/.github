# Design

## Fills

Say how the row loop maps to this backend (SIMD width, device threads per row, memory layout)
and which build switches change the code path but not the bits.

## Bounded integers

Say how bounded integers draw and reject, and which port's values they match.

## Normals

Say which normal algorithm each precision uses, where its tables come from, how a fill handles
misses, and which ports it matches bit for bit or within how many ulps.

## Exponentials

Say how exponentials map uniforms and which ports they match.
