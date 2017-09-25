package services;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;

public class Quiz implements Serializable {
    private String uuid;
    private String name;
    private HashMap<String, Integer> scoreboard = new HashMap<String, Integer>();
    private ArrayList<Question> questions = new ArrayList<Question>();
    private int duration_seconds;
    private long startTime; //seconds from 1970
    private ArrayList<String> chat = new ArrayList<String>();

    public HashMap<String, Integer> getScoreboard() {
        return scoreboard;
    }

    public void setScoreboard(HashMap<String, Integer> scoreboard) {
        this.scoreboard = scoreboard;
    }

    public Quiz(String name){
        this();
        this.name = name;

    }

    public Quiz(){uuid = UUID.randomUUID().toString();}

    public void addNick(String nick){
        scoreboard.put(nick, 0);
    }

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

    public long getStartTime() {return startTime;}
    public void setStartTime(long startTime) {this.startTime = startTime;}

    public ArrayList<String> getChat() {
        return chat;
    }
    public void setChat(ArrayList<String> chat) {
        this.chat = chat;
    }

    public void addChatLine(String message){
        chat.add(message);
    }
}
