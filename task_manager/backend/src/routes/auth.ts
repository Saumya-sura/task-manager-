import { Router,Request,Response } from "express";
import { db } from "../db/index";
import bcryptjs from "bcryptjs";
import { users, NewUser } from "../db/schema";
import { eq } from "drizzle-orm";
const authrouter = Router();
interface SignupBody{
    name:string;
    email:string;
    password:string;
}
authrouter.post("/signup",async (req:Request<{},{},SignupBody>, res:Response) => {
    try{
const {name, email, password} = req.body;
const existing_user= await db.select().from(users).where(eq(users.email,email));
if(existing_user.length ){
 res.status(400).json({error:"User already exists"});
 return;
}
    const hashedPassword= await bcryptjs.hash(password,8);
    const newUser:NewUser = {
       name,email,password:hashedPassword, 
    };
    const [user] = await db.insert(users).values(newUser).returning();
    }catch(e){
        res.status(500).json({error:e})
    }
});
authrouter.get("/", (req,res)=>{
    res.send("me aahe authyaa");
});
export default authrouter;

