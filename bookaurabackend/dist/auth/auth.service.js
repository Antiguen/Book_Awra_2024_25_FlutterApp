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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const bcrypt = require("bcrypt");
const jwt_1 = require("@nestjs/jwt");
const mailer_1 = require("@nestjs-modules/mailer");
const user_schema_1 = require("../schemas/user.schema");
const jwt = require("jsonwebtoken");
const user_role_enum_1 = require("../schemas/user-role.enum");
const profile_schema_1 = require("../schemas/profile.schema");
const common_2 = require("@nestjs/common");
const profile_service_1 = require("../profile/profile.service");
let AuthService = class AuthService {
    constructor(userModel, profileModel, jwtService, mailerService, profileService) {
        this.userModel = userModel;
        this.profileModel = profileModel;
        this.jwtService = jwtService;
        this.mailerService = mailerService;
        this.profileService = profileService;
    }
    async onModuleInit() {
        await this.createSuperAdmin();
    }
    async register(createUserDto) {
        const { userPassword, email, dateOfBirth, gender, fullName } = createUserDto;
        const user = await this.userModel.findOne({ email, used: false });
        if (user) {
            throw new common_1.HttpException("email ID is already used", common_1.HttpStatus.BAD_REQUEST);
        }
        const hashedPassword = await bcrypt.hash(userPassword, 10);
        const newUser = new this.userModel({
            ...createUserDto,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            userPassword: hashedPassword,
            status: true,
            used: true,
        });
        await newUser.save();
        await this.profileService.createIfNotExists({
            email: newUser.email,
            artist: newUser.fullName || newUser.email,
        });
        return newUser;
    }
    async sendVerificationCode(email) {
        const verificationCode = this.generateVerificationCode();
        await this.mailerService.sendMail({
            to: email,
            subject: "Email Verification",
            text: `Your verification code is ${verificationCode}`,
        });
        return verificationCode;
    }
    async verifyEmailCode(verifyEmailDto) {
        const { email, code } = verifyEmailDto;
        const user = await this.userModel.findOne({
            email,
            verificationCode: code,
        });
        if (user) {
            user.status = true;
            await user.save();
            return true;
        }
        return false;
    }
    async generateJwtToken(user) {
        const payload = {
            email: user.email,
            role: user.role,
        };
        const token = jwt.sign(payload, "your-secret-key", { expiresIn: "1h" });
        return token;
    }
    generateVerificationCode() {
        return Math.random().toString(36).substr(2, 6).toUpperCase();
    }
    async verifyUser(email, password) {
        const user = await this.userModel.findOne({ email, status: true });
        if (user && (await bcrypt.compare(password, user.userPassword))) {
            return true;
        }
        return false;
    }
    async sendPasswordResetEmail(email, verificationCode) {
        await this.mailerService.sendMail({
            to: email,
            subject: "Password Reset Verification Code",
            text: `Your password reset verification code is: ${verificationCode}`,
        });
    }
    async validateToken(token) {
        try {
            const decodedToken = this.jwtService.verify(token);
            const { email, role } = decodedToken;
            console.log(decodedToken);
            return { email, role };
        }
        catch (error) {
            throw new common_1.UnauthorizedException("Invalid token");
        }
    }
    async findByEmail(email) {
        return this.userModel.findOne({ email });
    }
    async changeUserRole(userId, newRole) {
        const user = await this.userModel.findOne({ userId });
        if (!user) {
            throw new common_1.HttpException("User not found", common_1.HttpStatus.NOT_FOUND);
        }
        user.role = newRole;
        return user.save();
    }
    async deleteUser(userId) {
        const result = await this.userModel.deleteOne({ userId: userId });
        if (result.deletedCount === 0) {
            throw new common_1.HttpException("User not found", common_1.HttpStatus.NOT_FOUND);
        }
    }
    async getAllUsers() {
        return this.userModel.find().exec();
    }
    async createProfile(token, createProfileDto) {
        try {
            const decodedToken = await this.validateToken(token);
            const userEmail = decodedToken.email;
            const user = await this.userModel.findOne({ email: userEmail });
            if (!user) {
                throw new common_1.HttpException("User not found", common_1.HttpStatus.NOT_FOUND);
            }
            const newProfile = new this.profileModel({
                ...createProfileDto,
                user: user._id,
            });
            return newProfile.save();
        }
        catch (error) {
            throw new common_1.HttpException(error.message || "Failed to create profile.", common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async updateProfile(token, updateProfileDto) {
        try {
            const decodedToken = await this.validateToken(token);
            const userEmail = decodedToken.email;
            const user = await this.userModel.findOne({ email: userEmail });
            if (!user) {
                throw new common_1.HttpException("User not found", common_1.HttpStatus.NOT_FOUND);
            }
            const profile = await this.profileModel.findOne({ user: user._id });
            if (!profile) {
                throw new common_1.HttpException("Profile not found", common_1.HttpStatus.NOT_FOUND);
            }
            Object.assign(profile, updateProfileDto);
            return profile.save();
        }
        catch (error) {
            throw new common_1.HttpException(error.message, common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async getProfile(token) {
        try {
            const decodedToken = await this.validateToken(token);
            const userEmail = decodedToken.email;
            const user = await this.userModel.findOne({ email: userEmail });
            if (!user) {
                throw new common_1.HttpException("User not found", common_1.HttpStatus.NOT_FOUND);
            }
            const profile = await this.profileModel.findOne({ user: user._id });
            if (!profile) {
                throw new common_1.HttpException("Profile not found", common_1.HttpStatus.NOT_FOUND);
            }
            return profile;
        }
        catch (error) {
            throw new common_1.HttpException(error.message || "Failed to fetch profile.", common_1.HttpStatus.BAD_REQUEST);
        }
    }
    async resetPassword(email) {
        const verificationCode = this.generateVerificationCode();
        await this.userModel.updateOne({ email }, { verificationCode });
        await this.sendPasswordResetEmail(email, verificationCode);
    }
    async getUserId(token) {
        try {
            const decodedToken = this.jwtService.verify(token);
            if (!decodedToken || typeof decodedToken.email !== "string") {
                throw new common_1.UnauthorizedException("Invalid token");
            }
            const userEmail = decodedToken.email;
            const user = await this.userModel.findOne({ email: userEmail });
            if (!user) {
                throw new common_1.UnauthorizedException("User not found");
            }
            return user._id.toString();
        }
        catch (error) {
            throw new common_1.UnauthorizedException("Invalid token");
        }
    }
    async createSuperAdmin() {
        const superAdminEmail = "yediworku@gmail.com";
        const superAdminGender = "female";
        const superAdminDataOfBirth = "1990-01-01";
        const superAdminPassword = "pass";
        const superAdminName = "yedi";
        const existingUser = await this.userModel.findOne({
            email: superAdminEmail,
        });
        if (!existingUser) {
            const hashedPassword = await bcrypt.hash(superAdminPassword, 10);
            const superAdmin = new this.userModel({
                fullName: superAdminName,
                email: superAdminEmail,
                gender: superAdminGender,
                dateOfBirth: superAdminDataOfBirth,
                userPassword: hashedPassword,
                role: user_role_enum_1.UserRole.SUPER_ADMIN,
                status: true,
            });
            await superAdmin.save();
            console.log("SuperAdmin user created successfully");
        }
        else {
            console.log("SuperAdmin user already exists");
        }
    }
    async registerArtist(createUserDto) {
        const { userPassword, email, dateOfBirth, gender, fullName } = createUserDto;
        const user = await this.userModel.findOne({ email, used: false });
        if (user) {
            throw new common_1.HttpException("email ID is already used", common_1.HttpStatus.BAD_REQUEST);
        }
        const hashedPassword = await bcrypt.hash(userPassword, 10);
        const newUser = new this.userModel({
            ...createUserDto,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            userPassword: hashedPassword,
            role: user_role_enum_1.UserRole.ARTIST,
            status: true,
            used: true,
        });
        await newUser.save();
        return newUser;
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(user_schema_1.User.name)),
    __param(1, (0, mongoose_1.InjectModel)(profile_schema_1.Profile.name)),
    __param(4, (0, common_2.Inject)((0, common_2.forwardRef)(() => profile_service_1.ProfileService))),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        jwt_1.JwtService,
        mailer_1.MailerService,
        profile_service_1.ProfileService])
], AuthService);
//# sourceMappingURL=auth.service.js.map