import {UUID} from "crypto";
import {  Request, Response } from "express";
import jwt  from "jsonwebtoken";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
    user?: UUID;
    token?: string;
}
export const auth = async(req:AuthRequest, res:Response, next:Function) => {
     try{
            const token = req.header("x-auth-token");
            if(!token){
                 res.status(401).json({error :"No token provided"});
                 return ;
            }
            const verified = jwt.verify(token, "passwordKey");
            if(!verified){
                res.status(400).json({error:" verification fialed "});
                 return
            }
            const verifiedToken = verified as {id:UUID};
            const users_result = await db.select().from(users).where(eq(users.id, verifiedToken.id));
            if(users_result.length === 0) { 
                res.status(400).json({error :"User not found"});  
                return;
            }
            req.user = verifiedToken.id;
            req.token = token;
            next();
        }catch(e){
            res.status(500).json({error:e})
        }
};