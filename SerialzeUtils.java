package com.happyelements.fortuna.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.DeflaterOutputStream;
import java.util.zip.InflaterInputStream;

public class SerialzeUtils {
	
private static final int COMPRESS_NEED = 100;
	
	private static final int NO_COMPRESS_FLAG = 0x00;
	private static final int DEFLATE_COMPRESS_FLAG = 0x40;
	
	private static final int COMPRESS_MASK = 0xc0;

	public static byte[] encode(byte[] obj) throws IOException {

		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		bout.write(0); // 占位
		if(obj != null) {
			DataOutputStream out = new DataOutputStream(bout);
			out.writeInt(obj.length);
			out.write(obj);
		}
		byte[] bytes = bout.toByteArray();
		bout.close();
		int flag = NO_COMPRESS_FLAG;
		if(bytes.length >= COMPRESS_NEED) {
			bytes = compress(bytes, 1, bytes.length - 1);
			flag = DEFLATE_COMPRESS_FLAG;
		} else {
			flag = NO_COMPRESS_FLAG;
		}
		bytes[0] = (byte)flag;
		return bytes;
	}

	public static byte[] decode(byte[] bytes) throws IOException {
		if (bytes == null || bytes.length < 2) {
			return null;
		}
		int flag = bytes[0] & 0xff;
		InputStream in = new ByteArrayInputStream(bytes, 1, bytes.length - 1);
		int compressFlag = flag & COMPRESS_MASK;
		if (compressFlag == DEFLATE_COMPRESS_FLAG) {	
			in = new InflaterInputStream(in);
		}
		DataInputStream dataInputStream = new DataInputStream(in);
		
		int byteLen = dataInputStream.readInt();
		byte[] messageBytes  = new byte[byteLen];
		dataInputStream.readFully(messageBytes);
		
		
		return messageBytes;
	}

	public static boolean isCompress(byte[] bytes){
		if (bytes == null || bytes.length < 2) {
			return false;
		}
		int flag = bytes[0] & 0xff;
		int compressFlag = flag & COMPRESS_MASK;
		if (compressFlag == DEFLATE_COMPRESS_FLAG) {	
			return true;
		}
		return false;
	}
	
	private static byte[] compress(byte[] src, int offset, int len) throws IOException {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		if (offset > 0) { // 先写入不需要压缩的部分
			bout.write(src, 0, offset);
		}
		DeflaterOutputStream zipOut = new DeflaterOutputStream(bout);
		try {
			zipOut.write(src, offset, len);
		} finally {
			zipOut.close();
		}
		return bout.toByteArray();
	}
}
