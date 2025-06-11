"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const common_1 = require("@nestjs/common");
const auth_service_1 = require("./auth.service");
const swagger_1 = require("@nestjs/swagger");
const create_user_dto_1 = require("../dto/create-user.dto");
const verify_email_dto_1 = require("../dto/verify-email.dto");
const login_dto_1 = require("../dto/login.dto");
const verify_email_response_dto_1 = require("../dto/verify-email-response.dto");
const auth_guard_1 = require("../guard/auth.guard");
const roles_decorator_1 = require("../guard/roles.decorator");
const user_role_enum_1 = require("../schemas/user-role.enum");
const change_role_dto_1 = require("../dto/change-role.dto");
const create_profile_dto_1 = require("../dto/create-profile.dto");
const update_profile_dto_1 = require("../dto/update-profile.dto");
const auth2_guard_1 = require("../guard/auth2.guard");
const reset_password_dto_1 = require("../dto/reset-password.dto");
let AuthController = class AuthController {
    constructor(authService) {
        this.authService = authService;
    }
    async register(createUserDto) {
        try {
            const newUser = await this.authService.register(createUserDto);
            return { message: 'User registered successfully. Verification code sent to your email.' };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async registerArtist(createUserDto) {
        try {
            const newUser = await this.authService.registerArtist(createUserDto);
            return { message: 'Artist registered successfully. Verification code sent to your email.' };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async verifyEmailCode(verifyEmailDto) {
        try {
            const isVerified = await this.authService.verifyEmailCode(verifyEmailDto);
            if (isVerified) {
                const user = await this.authService.findByEmail(verifyEmailDto.email);
                if (!user) {
                    throw new common_1.HttpException('User not found.', common_1.HttpStatus.NOT_FOUND);
                }
                const token = await this.authService.generateJwtToken(user);
                return { message: 'Email verified successfully.', token };
            }
            else {
                throw new common_1.HttpException('Invalid verification code or email.', common_1.HttpStatus.BAD_REQUEST);
            }
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async login(loginDto) {
        try {
            const { email, userPassword } = loginDto;
            const isvalidUser = await this.authService.verifyUser(email, userPassword);
            if (!isvalidUser) {
                throw new common_1.HttpException('Invalid email or password.', common_1.HttpStatus.UNAUTHORIZED);
            }
            const user = await this.authService.findByEmail(email);
            const token = await this.authService.generateJwtToken(user);
            return { accessToken: token };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    async changeUserRole(changeRoleDto) {
        try {
            const updatedUser = await this.authService.changeUserRole(changeRoleDto.userId, changeRoleDto.newRole);
            return { message: 'User role updated successfully.', user: updatedUser };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async deleteUser(userId) {
        try {
            await this.authService.deleteUser(userId);
            return { message: 'User deleted successfully.' };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getAllUsers() {
        try {
            const users = await this.authService.getAllUsers();
            return { users };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async createProfile(createProfileDto, req) {
        try {
            const token = req.headers.authorization.split(' ')[1];
            const profile = await this.authService.createProfile(token, createProfileDto);
            return { message: 'Profile created successfully.', profile };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async updateProfile(updateProfileDto, req) {
        try {
            const token = req.headers.authorization.split(' ')[1];
            const profile = await this.authService.updateProfile(token, updateProfileDto);
            return { message: 'Profile updated successfully.', profile };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getProfile(req) {
        try {
            const token = req.headers.authorization.split(' ')[1];
            const profile = await this.authService.getProfile(token);
            if (!profile) {
                throw new common_1.HttpException('Profile not found.', common_1.HttpStatus.NOT_FOUND);
            }
            return { profile };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async resetPassword(resetPasswordDto) {
        try {
            const { email } = resetPasswordDto;
            const user = await this.authService.findByEmail(email);
            if (!user) {
                throw new common_1.HttpException('User not found.', common_1.HttpStatus.NOT_FOUND);
            }
            const verificationCode = await this.authService.generateVerificationCode();
            await this.authService.sendPasswordResetEmail(email, verificationCode);
            return { message: 'Password reset email sent successfully.' };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getUserId(req) {
        try {
            const token = req.headers.authorization.split(' ')[1];
            const userId = await this.authService.getUserId(token);
            return { userId };
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
};
exports.AuthController = AuthController;
__decorate([
    (0, common_1.Post)('register'),
    (0, swagger_1.ApiOperation)({ summary: 'Register a new user' }),
    (0, swagger_1.ApiResponse)({ status: 201, description: 'The user has been successfully registered.' }),
    (0, swagger_1.ApiBody)({ type: create_user_dto_1.CreateUserDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "register", null);
__decorate([
    (0, common_1.Post)('register-artist'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, roles_decorator_1.Roles)(user_role_enum_1.UserRole.SUPER_ADMIN),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Register a new artist' }),
    (0, swagger_1.ApiResponse)({ status: 201, description: 'The artist has been successfully registered.' }),
    (0, swagger_1.ApiBody)({ type: create_user_dto_1.CreateUserDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "registerArtist", null);
__decorate([
    (0, common_1.Post)('verify-email'),
    (0, swagger_1.ApiOperation)({ summary: 'Verify email with verification code' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Email verified successfully.', type: verify_email_response_dto_1.VerifyEmailResponseDto }),
    (0, swagger_1.ApiBody)({ type: verify_email_dto_1.VerifyEmailDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [verify_email_dto_1.VerifyEmailDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "verifyEmailCode", null);
__decorate([
    (0, common_1.Post)('login'),
    (0, swagger_1.ApiOperation)({ summary: 'User login' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'User logged in successfully.' }),
    (0, swagger_1.ApiBody)({ type: login_dto_1.LoginDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [login_dto_1.LoginDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "login", null);
__decorate([
    (0, common_1.Put)('role'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, roles_decorator_1.Roles)(user_role_enum_1.UserRole.SUPER_ADMIN),
    (0, swagger_1.ApiOperation)({ summary: 'Change user role' }),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'User role updated successfully.' }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'User not found.' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [change_role_dto_1.ChangeRoleDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "changeUserRole", null);
__decorate([
    (0, common_1.Delete)(':userId'),
    (0, swagger_1.ApiOperation)({ summary: 'Delete a user' }),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'User deleted successfully.' }),
    __param(0, (0, common_1.Param)('userId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "deleteUser", null);
__decorate([
    (0, common_1.Get)(),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, roles_decorator_1.Roles)(user_role_enum_1.UserRole.SUPER_ADMIN),
    (0, swagger_1.ApiOperation)({ summary: 'Get all users' }),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Successfully retrieved users.' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "getAllUsers", null);
__decorate([
    (0, common_1.Post)('profile'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Create user profile' }),
    (0, swagger_1.ApiResponse)({ status: 201, description: 'Profile created successfully.' }),
    (0, swagger_1.ApiBody)({ type: create_profile_dto_1.CreateProfileDto }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_profile_dto_1.CreateProfileDto, Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "createProfile", null);
__decorate([
    (0, common_1.Put)('profile'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Update user profile' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Profile updated successfully.' }),
    (0, swagger_1.ApiBody)({ type: update_profile_dto_1.UpdateProfileDto }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [update_profile_dto_1.UpdateProfileDto, Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "updateProfile", null);
__decorate([
    (0, common_1.Get)('profile'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get profile of logged in user' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Successfully retrieved user profile.' }),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "getProfile", null);
__decorate([
    (0, common_1.Post)('reset-password'),
    (0, swagger_1.ApiOperation)({ summary: 'Reset password through email verification' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Password reset email sent successfully.' }),
    (0, swagger_1.ApiBody)({ type: reset_password_dto_1.ResetPasswordDto }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [reset_password_dto_1.ResetPasswordDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "resetPassword", null);
__decorate([
    (0, common_1.Get)('userid'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get user ID of authenticated user' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Successfully retrieved user ID.' }),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "getUserId", null);
exports.AuthController = AuthController = __decorate([
    (0, swagger_1.ApiTags)('auth'),
    (0, common_1.Controller)('auth'),
    __metadata("design:paramtypes", [auth_service_1.AuthService])
], AuthController);
//# sourceMappingURL=auth.controller.js.map