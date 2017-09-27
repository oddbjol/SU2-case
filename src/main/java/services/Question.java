package services;

import java.io.Serializable;
import java.util.ArrayList;

public class Question implements Serializable {
    private String question;
    private ArrayList<String> answers = new ArrayList<String>();
    private int right_answer;
    private String picture_url;
    private long duration_seconds;

    public long getDuration_seconds() {
        return duration_seconds;
    }

    public void setDuration_seconds(long duration_seconds) {
        this.duration_seconds = duration_seconds;
    }

    public Question(String question, ArrayList<String> answers, int right_answer, String picture_url, long duration_seconds){
        this.question = question;
        this.answers = answers;
        this.picture_url = picture_url;
        this.right_answer = right_answer;
        this.duration_seconds = duration_seconds;
    }

    public Question(String question, ArrayList<String> answers, int right_answer, String picture_url){
        this(question, answers, right_answer, picture_url,300);
    }

    public Question(String question, ArrayList<String> answers, int right_answer){
        this(question, answers, right_answer, null);
    }

    public Question(){}


    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public ArrayList<String> getAnswers() {
        return answers;
    }

    public void setAnswers(ArrayList<String> answers) {
        this.answers = answers;
    }

    public void addAnswer(String answer){
        answers.add(answer);
    }

    public int getRight_answer() {
        return right_answer;
    }

    public void setRight_answer(int right_answer) {
        this.right_answer = right_answer;
    }

    public String getPicture_url() {
        return picture_url;
    }

    public void setPicture_url(String picture_url) {
        this.picture_url = picture_url;
    }
}
