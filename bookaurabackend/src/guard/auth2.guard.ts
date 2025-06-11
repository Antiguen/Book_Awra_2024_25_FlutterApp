import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from "@nestjs/common";
import { AuthService } from "src/auth/auth.service";

@Injectable()
export class AuthenticatedGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    try {
      const request = context.switchToHttp().getRequest();
      const { authorization } = request.headers;
      console.log("Headers:", request.headers);
      if (!authorization) throw new UnauthorizedException("No token");
      const authToken = authorization.replace(/bearer /i, "").trim();
      const decodedData = await this.authService.validateToken(authToken);
      request.decodedData = decodedData;
      return true;
    } catch (error) {
      throw new UnauthorizedException(
        error.message || "Session expired! Please sign in"
      );
    }
  }
}
