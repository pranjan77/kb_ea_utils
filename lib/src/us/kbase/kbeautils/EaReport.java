
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
 * <p>Original spec-file type: ea_report</p>
 * <pre>
 * read_count - the number of reads in the this dataset
 *    total_bases - the total number of bases for all the the reads in this library.
 *    gc_content - the GC content of the reads.
 *    read_length_mean - The average read length size
 *    read_length_stdev - The standard deviation read lengths
 *    phred_type - The scale of phred scores
 *    number_of_duplicates - The number of reads that are duplicates
 *    qual_min - min quality scores
 *    qual_max - max quality scores
 *    qual_mean - mean quality scores
 *    qual_stdev - stdev of quality scores
 *    base_percentages - The per base percentage breakdown
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "read_count",
    "total_bases",
    "gc_content",
    "read_length_mean",
    "read_length_stdev",
    "phred_type",
    "number_of_duplicates",
    "qual_min",
    "qual_max",
    "qual_mean",
    "qual_stdev",
    "base_percentages"
})
public class EaReport {

    @JsonProperty("read_count")
    private Long readCount;
    @JsonProperty("total_bases")
    private Long totalBases;
    @JsonProperty("gc_content")
    private java.lang.Double gcContent;
    @JsonProperty("read_length_mean")
    private java.lang.Double readLengthMean;
    @JsonProperty("read_length_stdev")
    private java.lang.Double readLengthStdev;
    @JsonProperty("phred_type")
    private java.lang.String phredType;
    @JsonProperty("number_of_duplicates")
    private Long numberOfDuplicates;
    @JsonProperty("qual_min")
    private java.lang.Double qualMin;
    @JsonProperty("qual_max")
    private java.lang.Double qualMax;
    @JsonProperty("qual_mean")
    private java.lang.Double qualMean;
    @JsonProperty("qual_stdev")
    private java.lang.Double qualStdev;
    @JsonProperty("base_percentages")
    private Map<String, Double> basePercentages;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("read_count")
    public Long getReadCount() {
        return readCount;
    }

    @JsonProperty("read_count")
    public void setReadCount(Long readCount) {
        this.readCount = readCount;
    }

    public EaReport withReadCount(Long readCount) {
        this.readCount = readCount;
        return this;
    }

    @JsonProperty("total_bases")
    public Long getTotalBases() {
        return totalBases;
    }

    @JsonProperty("total_bases")
    public void setTotalBases(Long totalBases) {
        this.totalBases = totalBases;
    }

    public EaReport withTotalBases(Long totalBases) {
        this.totalBases = totalBases;
        return this;
    }

    @JsonProperty("gc_content")
    public java.lang.Double getGcContent() {
        return gcContent;
    }

    @JsonProperty("gc_content")
    public void setGcContent(java.lang.Double gcContent) {
        this.gcContent = gcContent;
    }

    public EaReport withGcContent(java.lang.Double gcContent) {
        this.gcContent = gcContent;
        return this;
    }

    @JsonProperty("read_length_mean")
    public java.lang.Double getReadLengthMean() {
        return readLengthMean;
    }

    @JsonProperty("read_length_mean")
    public void setReadLengthMean(java.lang.Double readLengthMean) {
        this.readLengthMean = readLengthMean;
    }

    public EaReport withReadLengthMean(java.lang.Double readLengthMean) {
        this.readLengthMean = readLengthMean;
        return this;
    }

    @JsonProperty("read_length_stdev")
    public java.lang.Double getReadLengthStdev() {
        return readLengthStdev;
    }

    @JsonProperty("read_length_stdev")
    public void setReadLengthStdev(java.lang.Double readLengthStdev) {
        this.readLengthStdev = readLengthStdev;
    }

    public EaReport withReadLengthStdev(java.lang.Double readLengthStdev) {
        this.readLengthStdev = readLengthStdev;
        return this;
    }

    @JsonProperty("phred_type")
    public java.lang.String getPhredType() {
        return phredType;
    }

    @JsonProperty("phred_type")
    public void setPhredType(java.lang.String phredType) {
        this.phredType = phredType;
    }

    public EaReport withPhredType(java.lang.String phredType) {
        this.phredType = phredType;
        return this;
    }

    @JsonProperty("number_of_duplicates")
    public Long getNumberOfDuplicates() {
        return numberOfDuplicates;
    }

    @JsonProperty("number_of_duplicates")
    public void setNumberOfDuplicates(Long numberOfDuplicates) {
        this.numberOfDuplicates = numberOfDuplicates;
    }

    public EaReport withNumberOfDuplicates(Long numberOfDuplicates) {
        this.numberOfDuplicates = numberOfDuplicates;
        return this;
    }

    @JsonProperty("qual_min")
    public java.lang.Double getQualMin() {
        return qualMin;
    }

    @JsonProperty("qual_min")
    public void setQualMin(java.lang.Double qualMin) {
        this.qualMin = qualMin;
    }

    public EaReport withQualMin(java.lang.Double qualMin) {
        this.qualMin = qualMin;
        return this;
    }

    @JsonProperty("qual_max")
    public java.lang.Double getQualMax() {
        return qualMax;
    }

    @JsonProperty("qual_max")
    public void setQualMax(java.lang.Double qualMax) {
        this.qualMax = qualMax;
    }

    public EaReport withQualMax(java.lang.Double qualMax) {
        this.qualMax = qualMax;
        return this;
    }

    @JsonProperty("qual_mean")
    public java.lang.Double getQualMean() {
        return qualMean;
    }

    @JsonProperty("qual_mean")
    public void setQualMean(java.lang.Double qualMean) {
        this.qualMean = qualMean;
    }

    public EaReport withQualMean(java.lang.Double qualMean) {
        this.qualMean = qualMean;
        return this;
    }

    @JsonProperty("qual_stdev")
    public java.lang.Double getQualStdev() {
        return qualStdev;
    }

    @JsonProperty("qual_stdev")
    public void setQualStdev(java.lang.Double qualStdev) {
        this.qualStdev = qualStdev;
    }

    public EaReport withQualStdev(java.lang.Double qualStdev) {
        this.qualStdev = qualStdev;
        return this;
    }

    @JsonProperty("base_percentages")
    public Map<String, Double> getBasePercentages() {
        return basePercentages;
    }

    @JsonProperty("base_percentages")
    public void setBasePercentages(Map<String, Double> basePercentages) {
        this.basePercentages = basePercentages;
    }

    public EaReport withBasePercentages(Map<String, Double> basePercentages) {
        this.basePercentages = basePercentages;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((((((((((((((((((((((((("EaReport"+" [readCount=")+ readCount)+", totalBases=")+ totalBases)+", gcContent=")+ gcContent)+", readLengthMean=")+ readLengthMean)+", readLengthStdev=")+ readLengthStdev)+", phredType=")+ phredType)+", numberOfDuplicates=")+ numberOfDuplicates)+", qualMin=")+ qualMin)+", qualMax=")+ qualMax)+", qualMean=")+ qualMean)+", qualStdev=")+ qualStdev)+", basePercentages=")+ basePercentages)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
