package com.qunar.fresh.Supermarket.Model;

/**
 * Created by Lumia_Saki on 15/5/23.
 */
public class Exhibit {
    private Integer majorValue;
    private String artist;
    private String exhibitURL;
    private String exhibitName;

    public Integer getMajorValue() {
        return majorValue;
    }

    public void setMajorValue(Integer majorValue) {
        this.majorValue = majorValue;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getExhibitURL() {
        return exhibitURL;
    }

    public void setExhibitURL(String exhibitURL) {
        this.exhibitURL = exhibitURL;
    }

    public String getExhibitName() {
        return exhibitName;
    }

    public void setExhibitName(String exhibitName) {
        this.exhibitName = exhibitName;
    }

    public Exhibit(Integer majorValue, String artist, String exhibitURL, String exhibitName) {
        this.majorValue = majorValue;
        this.artist = artist;
        this.exhibitURL = exhibitURL;
        this.exhibitName = exhibitName;
    }

    @Override
    public String toString() {
        return "[{\"exhibitName\" : " + "\"" + exhibitName + "\""  + "," + "\"" + "exhibitURL" +"\"" + ":" + "\"" + exhibitURL + "\"" + "," + "\"" + "artist" + "\"" + ":" + "\"" + artist + "\"" + "," + "\"" + "majorValue" + "\"" + ":" + majorValue + "}]";
    }
}
