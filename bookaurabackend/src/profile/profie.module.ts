import { forwardRef, Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { Profile, ProfileSchema } from "../schemas/profile.schema";
import { ProfileService } from "./profile.service";
import { SongsModule } from "../song/songs.module"; // <-- Import SongsModule
import { ProfileController } from "./profile.controller";
import { UserModule } from "../user/user.module";
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Profile.name, schema: ProfileSchema }]),
    SongsModule, // <-- Add this line
    UserModule,
    forwardRef(() => AuthModule), // <-- Add this line
  ],
  controllers: [ProfileController],
  providers: [ProfileService],
  exports: [ProfileService],
})
export class ProfileModule {}
