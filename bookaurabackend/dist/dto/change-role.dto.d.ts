import { UserRole } from 'src/schemas/user-role.enum';
export declare class ChangeRoleDto {
    userId: string;
    newRole: UserRole;
}
