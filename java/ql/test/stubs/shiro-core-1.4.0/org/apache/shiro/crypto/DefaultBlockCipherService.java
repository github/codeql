//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.apache.shiro.crypto;

public class DefaultBlockCipherService extends AbstractSymmetricCipherService {
    private static final int DEFAULT_BLOCK_SIZE = 0;
    private static final String TRANSFORMATION_STRING_DELIMITER = "/";
    private static final int DEFAULT_STREAMING_BLOCK_SIZE = 8;
    private String modeName;
    private int blockSize;
    private String paddingSchemeName;
    private String streamingModeName;
    private int streamingBlockSize;
    private String streamingPaddingSchemeName;
    private String transformationString;
    private String streamingTransformationString;

    public DefaultBlockCipherService(String algorithmName) {
        super(algorithmName);
        this.modeName = OperationMode.CBC.name();
        this.paddingSchemeName = PaddingScheme.PKCS5.getTransformationName();
        this.blockSize = 0;
        this.streamingModeName = OperationMode.CBC.name();
        this.streamingPaddingSchemeName = PaddingScheme.PKCS5.getTransformationName();
        this.streamingBlockSize = 8;
    }

    public String getModeName() {
        return null;
    }

    public void setModeName(String modeName) {
    }

    public void setMode(OperationMode mode) {
    }

    public String getPaddingSchemeName() {
        return null;
    }

    public void setPaddingSchemeName(String paddingSchemeName) {
       
    }

    public void setPaddingScheme(PaddingScheme paddingScheme) {

    }

    public int getBlockSize() {
       return 1;
    }

    public void setBlockSize(int blockSize) {
    }

    public String getStreamingModeName() {
       return null;
    }

    private boolean isModeStreamingCompatible(String modeName) {
        return false;
    }

    public void setStreamingModeName(String streamingModeName) {
      
    }

    public void setStreamingMode(OperationMode mode) {

    }

    public String getStreamingPaddingSchemeName() {
       return null;
    }

    public void setStreamingPaddingSchemeName(String streamingPaddingSchemeName) {
    }

    public void setStreamingPaddingScheme(PaddingScheme scheme) {
    }

    public int getStreamingBlockSize() {
       return 1;
    }

    public void setStreamingBlockSize(int streamingBlockSize) {
    }

    protected String getTransformationString(boolean streaming) {
      return null;
    }

    private String buildTransformationString() {
        return null;
    }

    private String buildStreamingTransformationString() {
        return null;
    }

    private String buildTransformationString(String modeName, String paddingSchemeName, int blockSize) {
      return null;
    }

    private boolean isModeInitializationVectorCompatible(String modeName) {
       return false;
    }

    protected boolean isGenerateInitializationVectors(boolean streaming) {
        return false;
    }

    protected byte[] generateInitializationVector(boolean streaming) {
       return null;
    }
}
