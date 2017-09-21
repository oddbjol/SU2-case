package services;

import javax.ws.rs.*;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Path("/quizes/")
public class AService {

    private static HashMap<String, Quiz> quizes = new HashMap<String, Quiz>();
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
        quizes.get(uuid).addNick(nick);

        return Response.ok().build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("quiz")
    public void addQuiz(Quiz quiz){
        quizes.put(quiz.getUuid(), quiz);
    }


}
