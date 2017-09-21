package services;

import javax.ws.rs.*;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

/**
 * @author nilstes
 */
@Path("/quizes/")
public class AService {

    private static HashMap<String, Quiz> quizes = new HashMap<String, Quiz>();
    static{
        Quiz quiz = new Quiz("A test quiz");
        quiz.addQuestion(new Question("What is 2+2?",new String[]{"4","3","2"},0));
        quiz.addNick("Odd");
        quiz.addNick("Bob");
        quiz.setUuid("e0988628-e398-45e0-8c01-77315be8056f");
        quizes.put(quiz.getUuid(), quiz);
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
        System.out.println("asking for it");
        System.out.println(quizes.size());
        return quizes.get(uuid.trim());
    }

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Path("quiz/{uuid}/join")
    public Response joinQuiz(@PathParam("uuid") String uuid, String nick){
        System.out.println("The uuid: " + uuid);
        System.out.println("The nick: " + nick);

        quizes.get(uuid).addNick(nick);

        return Response.ok().build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("quiz")
    public void addQuiz(Quiz quiz){
        quizes.put(UUID.randomUUID().toString(), quiz);
    }


}
