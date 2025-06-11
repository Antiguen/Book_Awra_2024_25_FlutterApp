import { AuthService } from './auth.service';
import { CreateUserDto } from 'src/dto/create-user.dto';
import { VerifyEmailDto } from 'src/dto/verify-email.dto';
import { LoginDto } from 'src/dto/login.dto';
import { User } from 'src/schemas/user.schema';
import { ChangeRoleDto } from 'src/dto/change-role.dto';
import { CreateProfileDto } from 'src/dto/create-profile.dto';
import { UpdateProfileDto } from 'src/dto/update-profile.dto';
import { ResetPasswordDto } from 'src/dto/reset-password.dto';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    register(createUserDto: CreateUserDto): Promise<{
        message: string;
    }>;
    registerArtist(createUserDto: CreateUserDto): Promise<{
        message: string;
    }>;
    verifyEmailCode(verifyEmailDto: VerifyEmailDto): Promise<{
        message: string;
        token: string;
    }>;
    login(loginDto: LoginDto): Promise<{
        accessToken: string;
    }>;
    changeUserRole(changeRoleDto: ChangeRoleDto): Promise<{
        message: string;
        user: User;
    }>;
    deleteUser(userId: string): Promise<{
        message: string;
    }>;
    getAllUsers(): Promise<{
        users: User[];
    }>;
    createProfile(createProfileDto: CreateProfileDto, req: any): Promise<{
        message: string;
        profile: import("../schemas/profile.schema").Profile;
    }>;
    updateProfile(updateProfileDto: UpdateProfileDto, req: any): Promise<{
        message: string;
        profile: import("../schemas/profile.schema").Profile;
    }>;
    getProfile(req: any): Promise<{
        profile: import("../schemas/profile.schema").Profile;
    }>;
    resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{
        message: string;
    }>;
    getUserId(req: any): Promise<{
        userId: string;
    }>;
}
