//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.apache.shiro.codec;

public class Base64 {
    static final int CHUNK_SIZE = 76;
    static final byte[] CHUNK_SEPARATOR = "\r\n".getBytes();
    private static final int BASELENGTH = 255;
    private static final int LOOKUPLENGTH = 64;
    private static final int EIGHTBIT = 8;
    private static final int SIXTEENBIT = 16;
    private static final int TWENTYFOURBITGROUP = 24;
    private static final int FOURBYTE = 4;
    private static final int SIGN = -128;
    private static final byte PAD = 61;
    private static final byte[] base64Alphabet = new byte[255];
    private static final byte[] lookUpBase64Alphabet = new byte[64];

    public Base64() {
    }


    public static byte[] decode(String base64Encoded) {
        byte[] bytes = new byte[1024];
        return decode(bytes);
    }

    public static byte[] decode(byte[] base64Data) {
            return base64Data;
        }
    }


