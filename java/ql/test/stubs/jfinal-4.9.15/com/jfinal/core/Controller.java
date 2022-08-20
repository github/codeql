package com.jfinal.core;

import java.io.File;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.jfinal.kit.Kv;
import com.jfinal.upload.UploadFile;

public abstract class Controller {
	public String getPara(String name) {
		return null;
	}

	public String getPara(String name, String defaultValue) {
		return null;
	}

	public Map<String, String[]> getParaMap() {
		return null;
	}

	public Enumeration<String> getParaNames() {
		return null;
	}

	public String[] getParaValues(String name) {
		return null;
	}

	public Integer[] getParaValuesToInt(String name) {
		return null;
	}

	public Long[] getParaValuesToLong(String name) {
		return null;
	}

	public Controller setAttr(String name, Object value) {
		return null;
	}

	public Controller setAttrs(Map<String, Object> attrMap) {
		return null;
	}

	public Enumeration<String> getAttrNames() {
		return null;
	}

	public <T> T getAttr(String name) {
		return null;
	}

	public <T> T getAttr(String name, T defaultValue) {
		return null;
	}

	public String getAttrForStr(String name) {
		return null;
	}

	public Integer getAttrForInt(String name) {
		return -1;
	}

	public String getHeader(String name) {
		return null;
	}

	public Integer getParaToInt(String name) {
		return null;
	}

	public Integer getParaToInt(String name, Integer defaultValue) {
		return null;
	}

	public Long getParaToLong(String name) {
		return null;
	}

	public Long getParaToLong(String name, Long defaultValue) {
		return null;
	}

	public Boolean getParaToBoolean(String name) {
		return false;
	}

	public Boolean getParaToBoolean(String name, Boolean defaultValue) {
		return false;
	}

	public Boolean getParaToBoolean() {
		return false;
	}

	public Boolean getParaToBoolean(int index) {
		return false;
	}

	public Boolean getParaToBoolean(int index, Boolean defaultValue) {
		return false;
	}

	public Date getParaToDate(String name) {
		return null;
	}

	public Date getParaToDate(String name, Date defaultValue) {
		return null;
	}

	public Date getParaToDate() {
		return null;
	}

	public HttpServletRequest getRequest() {
		return null;
	}

	public HttpServletResponse getResponse() {
		return null;
	}

	public HttpSession getSession() {
		return null;
	}

	public HttpSession getSession(boolean create) {
		return null;
	}

	public <T> T getSessionAttr(String key) {
		return null;
	}

	public <T> T getSessionAttr(String key, T defaultValue) {
		return null;
	}

	public Controller setSessionAttr(String key, Object value) {
		return null;
	}

	public String getCookie(String name, String defaultValue) {
		return null;
	}
	
	public String getCookie(String name) {
		return null;
	}

	public Integer getCookieToInt(String name) {
		return null;
	}

	public Integer getCookieToInt(String name, Integer defaultValue) {
		return null;
	}

	public Long getCookieToLong(String name) {
		return null;
	}

	public Long getCookieToLong(String name, Long defaultValue) {
		return null;
	}

	public Cookie getCookieObject(String name) {
		return null;
	}

	public Cookie[] getCookieObjects() {
		return null;
	}

	public String getPara() {
		return null;
	}

	public String getPara(int index) {
		return null;
	}

	public String getPara(int index, String defaultValue) {
		return null;
	}

	public Integer getParaToInt(int index) {
		return null;
	}

	public Integer getParaToInt(int index, Integer defaultValue) {
		return null;
	}

	public Long getParaToLong(int index) {
		return null;
	}

	public Long getParaToLong(int index, Long defaultValue) {
		return null;
	}

	public Integer getParaToInt() {
		return null;
	}

	public Long getParaToLong() {
		return null;
	}

	public Kv getKv() {
		return null;
	}

	public List<UploadFile> getFiles(String uploadPath, Integer maxPostSize, String encoding) {
		return null;
	}

	public UploadFile getFile(String parameterName, String uploadPath, Integer maxPostSize, String encoding) {
		return null;
	}

	public List<UploadFile> getFiles(String uploadPath, int maxPostSize) {
		return null;
	}

	public UploadFile getFile(String parameterName, String uploadPath, int maxPostSize) {
		return null;
	}

	public List<UploadFile> getFiles(String uploadPath) {
		return null;
	}

	public UploadFile getFile(String parameterName, String uploadPath) {
		return null;
	}

	public List<UploadFile> getFiles() {
		return null;
	}

	public UploadFile getFile() {
		return null;
	}

	public UploadFile getFile(String parameterName) {
		return null;
	}

	public Controller set(String attributeName, Object attributeValue) {
		return null;
	}

	public String get(String name) {
		return null;
	}

	public String get(String name, String defaultValue) {
		return null;
	}

	public Integer getInt(String name) {
		return -1;
	}

	public Integer getInt(String name, Integer defaultValue) {
		return -1;
	}

	public Long getLong(String name) {
		return null;
	}

	public Long getLong(String name, Long defaultValue) {
		return null;
	}

	public Boolean getBoolean(String name) {
		return false;
	}

	public Boolean getBoolean(String name, Boolean defaultValue) {
		return false;
	}

	public Date getDate(String name) {
		return null;
	}

	public Date getDate(String name, Date defaultValue) {
		return null;
	}

	public String get(int index) {
		return null;
	}

	public String get(int index, String defaultValue) {
		return null;
	}

	public Integer getInt() {
		return -1;
	}

	public Integer getInt(int index) {
		return -1;
	}

	public Integer getInt(int index, Integer defaultValue) {
		return -1;
	}

	public Long getLong() {
		return null;
	}

	public Long getLong(int index) {
		return null;
	}

	public Long getLong(int index, Long defaultValue) {
		return null;
	}

	public Boolean getBoolean() {
		return false;
	}

	public Boolean getBoolean(int index) {
		return false;
	}

	public Boolean getBoolean(int index, Boolean defaultValue) {
		return false;
	}
}
