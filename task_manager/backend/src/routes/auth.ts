import { Router,Request,Response } from "express";
import { db } from "../db/index";
import bcryptjs from "bcryptjs";
import { users, NewUser } from "../db/schema";
import { eq } from "drizzle-orm";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";
const authrouter = Router();
interface SignupBody{
    name:string;
    email:string;
    password:string;
}

interface LoginBody{
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
    res.status(201).json(user);
    }catch(e){
        res.status(500).json({error:e})
    }
});
authrouter.post("/login",async (req:Request<{},{},LoginBody>, res:Response) => {
    try{
const {email, password} = req.body;

const existing_users = await db.select().from(users).where(eq(users.email,email));
if(existing_users.length === 0){
 res.status(400).json({error:"User with email doesn't exist"});
 return;
}
const existing_user = existing_users[0];

    const isMatch= await bcryptjs.compare(password,existing_user.password);
    if(!isMatch){
    res.status(400).json({error:"Invalid credentials"});
    return;

    }
        const token = jwt.sign({id:existing_user.id},"passwordKey");
    res.status(201).json({token,...existing_user});
    }catch(e){
        res.status(500).json({error:e})
    }
});

authrouter.post("/tokenIsValid",async(req, res)=>{
    try{
        const token = req.header("x-auth-token");
        if(!token){
             res.json(false);
             return ;
        }
        const verified = jwt.verify(token, "passwordKey");
        if(!verified){
            res.json(false);
             return
        }
        const verifiedToken = verified as {id:string};
        const users_result = await db.select().from(users).where(eq(users.id, verifiedToken.id));
        if(users_result.length === 0) { res.json(false);  return;}
        res.json(true);
    }catch(e){
        res.status(500).json({error:e})
    }
});

authrouter.get("/",auth, (req:AuthRequest,res)=>{
   try{
    if(!req.user){
        res.status(401).json({msg:" User not found"});
        return;
    }
    
    db.select().from(users).where(eq(users.id, req.user))
      .then(userData => {
        if (userData.length === 0) {
          res.status(404).json({msg: "User not found in database"});
          return;
        }
        res.json({...userData[0], token: req.token});
      })
      .catch(error => {
        res.status(500).json({error});
      });
   }catch(e){
         res.status(500).json(false);
    }
});
export default authrouter;

