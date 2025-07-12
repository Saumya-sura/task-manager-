import { pgTable, text, uuid, timestamp } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    created_at: timestamp("created_at").notNull().defaultNow(),
    updated_at: timestamp("updated_at").notNull().defaultNow()
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

export const tasks = pgTable("tasks",{
    id: uuid("id").primaryKey().defaultRandom(),
   
    title: text("title").notNull(),
    description: text("description").notNull(),
    hexColor:text("hexColor").notNull(),
    uid:uuid("uid").notNull().references(()=>users.id,{onDelete:"cascade"}),
    dueAt: timestamp("dueAt").$defaultFn(()=>new Date(Date.now()+7*24*60*60*1000)),
    created_at: timestamp("created_at").notNull().defaultNow(),
    updated_at: timestamp("updated_at").notNull().defaultNow()
});
export type Task = typeof tasks.$inferSelect;
export type NewTask = typeof tasks.$inferInsert;