// The four streams of cross-port/README.md from tandem-java's pure Java fills:
//   java -cp <port>/target/classes TandemJava.java OUT

import io.github.tandemrng.Tandem;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.file.Path;

class TandemJava {
    static final int N = 1_000_000;
    static final long[] STARTS = {0, 1, 77, 12345, 1L << 30};

    static Tandem at(long start) {
        Tandem g = Tandem.seed(2026, 7);
        g.setPosition(start);
        return g;
    }

    static ByteBuffer le(int bytes) {
        return ByteBuffer.allocate(bytes).order(ByteOrder.LITTLE_ENDIAN);
    }

    static void put(OutputStream o, int[] a) throws IOException {
        ByteBuffer b = le(4 * a.length);
        b.asIntBuffer().put(a);
        o.write(b.array());
    }

    static void put(OutputStream o, float[] a) throws IOException {
        ByteBuffer b = le(4 * a.length);
        b.asFloatBuffer().put(a);
        o.write(b.array());
    }

    static void put(OutputStream o, double[] a) throws IOException {
        ByteBuffer b = le(8 * a.length);
        b.asDoubleBuffer().put(a);
        o.write(b.array());
    }

    static OutputStream open(String dir, String name) throws IOException {
        return new BufferedOutputStream(new FileOutputStream(Path.of(dir, name).toFile()));
    }

    public static void main(String[] args) throws IOException {
        int[] u = new int[N];
        double[] d = new double[N];
        float[] f = new float[N];
        try (OutputStream uniform = open(args[0], "uniform.bin");
                OutputStream bounded = open(args[0], "bounded.bin");
                OutputStream normal = open(args[0], "normal.bin");
                OutputStream exponential = open(args[0], "exponential.bin")) {
            for (long s : STARTS) {
                Tandem g = at(s);
                g.fill(u);
                put(uniform, u);
                g.fill(d);
                put(uniform, d);

                g = at(s);
                g.fillBelowU32(u, 0, N, 1000);
                put(bounded, u);
                g.fillBelowU32(u, 0, N, (int) 3221225473L);
                put(bounded, u);

                g = at(s);
                g.fillGaussian(d);
                put(normal, d);

                g = at(s);
                g.fillExponential(d);
                put(exponential, d);
                g.fillExponential(f);
                put(exponential, f);
            }
        }
    }
}
