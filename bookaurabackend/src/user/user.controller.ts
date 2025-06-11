import { Controller, Get, Put, UseGuards, Req, Body, NotFoundException } from '@nestjs/common';
import { AuthenticatedGuard } from '../guard/auth2.guard';
import { UserService } from './user.service';
import { ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { UploadedFile, UseInterceptors } from '@nestjs/common/decorators';

@ApiTags('users')
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('me')
  @UseGuards(AuthenticatedGuard)
  async getMe(@Req() req) {
    const email = req.decodedData?.email || req.user?.email;
    const user = await this.userService.findByEmail(email);
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  @Put('library/add')
  @UseGuards(AuthenticatedGuard)
  async addToLibrary(@Req() req, @Body('bookId') bookId: string) {
    const email = req.decodedData?.email || req.user?.email;
    const user = await this.userService.findByEmail(email);
    if (!user) throw new NotFoundException('User not found');
    if (!user.library) user.library = [];
    if (!user.library.includes(bookId)) {
      user.library.push(bookId);
      await user.save();
    }
    return { library: user.library };
  }

  @Put('library/remove')
  @UseGuards(AuthenticatedGuard)
  async removeFromLibrary(@Req() req, @Body('bookId') bookId: string) {
    const email = req.decodedData?.email || req.user?.email;
    const user = await this.userService.findByEmail(email);
    if (!user) throw new NotFoundException('User not found');
    if (!user.library) user.library = [];
    user.library = user.library.filter(id => id !== bookId);
    await user.save();
    return { library: user.library };
  }

  @Put('me')
  @UseGuards(AuthenticatedGuard)
  @UseInterceptors(FileInterceptor('image'))
  async updateMe(
    @Req() req,
    @Body() body,
    @UploadedFile() image?: Express.Multer.File,
  ) {
    const email = req.decodedData?.email || req.user?.email;
    const user = await this.userService.findByEmail(email);
    if (!user) throw new NotFoundException('User not found');
    user.fullName = body.fullName ?? user.fullName;
    user.bio = body.bio ?? user.bio;
    user.genre = body.genre ?? user.genre;
    user.description = body.description ?? user.description;
    if (image) {
      user.imageData = image.buffer;
      user.imageContentType = image.mimetype;
    }
    await user.save();
    return user;
  }
}