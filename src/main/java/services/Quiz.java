package services;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

public class Quiz implements Serializable {
    private String uuid;
    private String name;
    private ArrayList<String> nicks = new ArrayList<String>();
    private ArrayList<Question> questions = new ArrayList<Question>();
    private int duration_seconds;
    private long startTime; //seconds from 1970

    public Quiz(String name){
        this();
        this.name = name;
    }

    public Quiz(){uuid = UUID.randomUUID().toString();}

    public void addNick(String nick){nicks.add(nick);}

    public void addQuestion(Question question){
        questions.add(question);
        duration_seconds += question.getDuration_seconds();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(ArrayList<Question> questions) {
        this.questions = questions;
    }

    public int getDuration_seconds() {
        return duration_seconds;
    }

    public void setDuration_seconds(int duration_seconds) {
        this.duration_seconds = duration_seconds;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public ArrayList<String> getNicks() {
        return nicks;
    }

    public void setNicks(ArrayList<String> nicks) {
        this.nicks = nicks;
    }

    public long getStartTime() {return startTime;}
    public void setStartTime(long startTime) {this.startTime = startTime;}

}
