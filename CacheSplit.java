package com.happyelements.fortuna.util;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import com.happyelements.fortuna.lua.helper.ErrorHelper;
import com.happyelements.rdcenter.commons.util.CollectionUtil;

public class CacheSplit {

private static final int SPLIT_SIZE = 512 * 1024;
	
	public static boolean isNeedSplit(byte[] detail){
		if(detail == null || detail.length < 1024*1024){
			return false;
		}
		return true;
	}
	
	public static byte[][] splitDetail(byte[] detail){
		int length = detail.length;
		int chunkNum = (length + SPLIT_SIZE - 1) / SPLIT_SIZE;
		byte[][] result = new byte[chunkNum][];
		int offset = 0;
		for(int i=0; i<chunkNum; i++){
			int chunkLength = length - offset > SPLIT_SIZE ? SPLIT_SIZE : length - offset;
			byte[] chunkByte = new byte[chunkLength];
			System.arraycopy(detail, offset, chunkByte, 0, chunkLength);
			result[i] = chunkByte;
			offset += chunkLength;
		}
		return result;
	}
	
	public static void multiSetCache(byte[][] bytes, String mainPrefix, int expireSec){
		if(bytes == null || bytes.length == 0){
			return;
		}
		int chunks = bytes.length;
		try {
			for(int i=0; i<chunks; i++){
				String subKey = mainPrefix + "_" + i;
				CacheUtils.getInstance().setToDataCache(subKey, bytes[i], expireSec);
			}
			CacheUtils.getInstance().setToDataCache(mainPrefix, chunks, expireSec);
		} catch (Exception e) {
			ErrorHelper.logError("", e);
			for(int i=0; i<chunks; i++){
				String subKey = mainPrefix + "_" + i;
				CacheUtils.getInstance().deleteFromDataCache(subKey);
			}
			CacheUtils.getInstance().deleteFromDataCache(mainPrefix);
		}
	}
	
	public static byte[] multiGet(String mainPrefix, int chunkNum){
		List<String> subKeys = CollectionUtil.newArrayList();
		for(int i=0; i<chunkNum; i++){
			subKeys.add(mainPrefix + "_" + i);
		}
		byte[] o = new byte[0];
		Map<String, Object> maps = CacheUtils.getInstance().getDataBulk(subKeys);
		if(MapUtils.isEmpty(maps)){
			return null;
		}
		for(String key : subKeys){
			byte[] b = (byte[])maps.get(key);
			o = union(o, b);
		}
		return o;
	}
	
	public static byte[] union(byte[] b1, byte[] b2){
		if(b1 == null || b2 == null){
			return null;
		}
		byte[] result = new byte[b1.length + b2.length];
		System.arraycopy(b1, 0, result, 0, b1.length);
		System.arraycopy(b2, 0, result, b1.length, b2.length);
		return result;
	}
}
