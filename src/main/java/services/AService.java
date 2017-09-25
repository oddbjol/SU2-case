package services;

import javax.ws.rs.*;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Path("/quizes/")
public class AService {

    private static HashMap<String, Quiz> quizes = new HashMap<String, Quiz>();

    static{
        for(int i = 0; i < 50; i++){
            Quiz quiz = new Quiz("Quiz " + i);
            Question q1 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q2 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q3 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q4 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q5 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q6 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);
            Question q7 = new Question("Question 1",new String[]{"wrong","right","wrong"},1,"",20);

            quiz.addQuestion(q1);
            quiz.addQuestion(q2);
            quiz.addQuestion(q3);
            quiz.addQuestion(q4);
            quiz.addQuestion(q5);
            quiz.addQuestion(q6);
            quiz.addQuestion(q7);

            quiz.setStartTime((new Date().getTime()/1000)+i*140);
            quiz.setDuration_seconds(140);
            quiz.addNick("testperson");
            if(i == 0) // first quiz gets extra contestant for testing purposes
                quiz.addNick("testperson 2");

            quizes.put(quiz.getUuid(), quiz);
        }
    }

    @GET 
    @Produces(MediaType.APPLICATION_JSON)
    public Response getQuizzes() {
        GenericEntity<List<Quiz>> genericEntity = new GenericEntity<List<Quiz>>(new ArrayList<Quiz>(quizes.values())) {};
        return Response.ok(genericEntity).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("quiz/{uuid}")
    public Quiz getQuiz(@PathParam("uuid") String uuid){
        return quizes.get(uuid.trim());
    }

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Path("quiz/{uuid}/join")
    public Response joinQuiz(@PathParam("uuid") String uuid, String nick){
        uuid=uuid.trim();
        nick=nick.trim();

        Quiz curQuiz = quizes.get(uuid);
        HashMap<String, Integer> curScoreboard = curQuiz.getScoreboard();

        int score = 0;

        // If user is already participating in quiz, don't re-add him. return his current score.
        if(curScoreboard.containsKey(nick))
            score = curScoreboard.get(nick);
        else
            curQuiz.addNick(nick);

        return Response.ok(score).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("quiz/{uuid}/chat")
    public Response getChat(@PathParam("uuid") String uuid){
        uuid=uuid.trim();

        Quiz curQuiz = quizes.get(uuid);

        ArrayList<String> chat = curQuiz.getChat();

        return Response.ok(chat).build();
    }

    @POST
    @Consumes(MediaType.TEXT_PLAIN)
    @Path("quiz/{uuid}/chat")
    public Response addChatLine(@PathParam("uuid") String uuid, String message){
        uuid=uuid.trim();
        message=message.trim();

        Quiz curQuiz = quizes.get(uuid);

        curQuiz.addChatLine(message);

        return Response.ok().build();
    }


    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("quiz/{uuid}/setScore/{nick}")
    public Response setScore(@PathParam("uuid") String uuid, @PathParam("nick") String nick, int score){
        uuid=uuid.trim();
        nick=nick.trim();

        Quiz curQuiz = quizes.get(uuid);
        HashMap<String, Integer> curScoreboard = curQuiz.getScoreboard();

        curScoreboard.put(nick, score);

        return Response.ok().build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("quiz")
    public void addQuiz(Quiz quiz){
        quizes.put(quiz.getUuid(), quiz);
    }


}
