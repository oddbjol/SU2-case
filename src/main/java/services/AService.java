package services;

import javax.ws.rs.*;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.*;

@Path("/quizes/")
public class AService {

    private static HashMap<String, Quiz> quizes = new HashMap<String, Quiz>();

    // debug code
    static{

        int num_quizes = 20;
        int question_duration = 10;
        int num_questions = 10;
        int min_answers = 2;
        int max_answers = 6;


        for(int i = 0; i < num_quizes; i++){
            Quiz quiz = new Quiz("Quiz " + i);

            for(int j = 0; j < num_questions; j++){
                int num_answers = randomInt(min_answers, max_answers);
                int right_answer = randomInt(0, num_answers-1);

                ArrayList<String> answers = new ArrayList<String>();

                for(int k = 0; k < num_answers; k++)
                    answers.add("Alternative " + (k+1) + (k == right_answer ? " (right) " : " (wrong) "));

                Question q = new Question("Question " + (j+1), answers, right_answer, "", question_duration);
                quiz.addQuestion(q);
            }
            long now = new Date().getTime()/1000;
            quiz.setStartTime(now + i *(num_questions*question_duration));
            quiz.addNick("testperson");
            quiz.addNick("testperson 2");

            quiz.addChatLine("&lt;someone&gt;: What is this?");
            quiz.addChatLine("&lt;someone else&gt;: Looks like a chat.");
            quiz.addChatLine("&lt;someone&gt;: How do we use it?");
            quiz.addChatLine("&lt;someone else&gt;: Just type something, duh...");

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

    /**
     * Returns random number between min (inclusive) and max (inclusive)
     * @param min
     * @param max
     * @return
     */
    private static int randomInt(int min, int max){
        return (new Random()).nextInt(max - min + 1) + min;
    }
}
