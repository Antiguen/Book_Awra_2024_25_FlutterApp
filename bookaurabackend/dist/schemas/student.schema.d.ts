import { Document } from 'mongoose';
export declare class Student extends Document {
    studentId: string;
    studentPassword: string;
    used: boolean;
}
export declare const StudentSchema: import("mongoose").Schema<Student, import("mongoose").Model<Student, any, any, any, Document<unknown, any, Student, any> & Student & Required<{
    _id: unknown;
}> & {
    __v: number;
}, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Student, Document<unknown, {}, import("mongoose").FlatRecord<Student>, {}> & import("mongoose").FlatRecord<Student> & Required<{
    _id: unknown;
}> & {
    __v: number;
}>;
