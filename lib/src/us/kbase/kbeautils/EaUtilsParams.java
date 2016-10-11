
package us.kbase.kbeautils;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: ea_utils_params</p>
 * <pre>
 * read_library_path : absolute path of fastq files
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "read_library_path"
})
public class EaUtilsParams {

    @JsonProperty("read_library_path")
    private String readLibraryPath;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("read_library_path")
    public String getReadLibraryPath() {
        return readLibraryPath;
    }

    @JsonProperty("read_library_path")
    public void setReadLibraryPath(String readLibraryPath) {
        this.readLibraryPath = readLibraryPath;
    }

    public EaUtilsParams withReadLibraryPath(String readLibraryPath) {
        this.readLibraryPath = readLibraryPath;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((("EaUtilsParams"+" [readLibraryPath=")+ readLibraryPath)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
