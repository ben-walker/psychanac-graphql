import { PrismaClient } from "@prisma/client";
import { argon2id, hash } from "argon2";

const prisma = new PrismaClient();

export const seed = async (): Promise<void> => {
  const passwordHash = await hash("password", { type: argon2id });

  await prisma.user.createMany({
    data: [
      { id: "1", email: "fox@email.com", passwordHash },
      { id: "2", email: "cow@email.com", passwordHash },
      { id: "3", email: "dog@email.com", passwordHash },
      { id: "4", email: "cat@email.com", passwordHash },
      { id: "5", email: "bull@email.com", passwordHash },
    ],
    skipDuplicates: true,
  });

  await prisma.shop.createMany({
    data: [
      { id: "1", name: "Cat's Organic Produce" },
      { id: "2", name: "Bull's Decadent Legumes" },
    ],
    skipDuplicates: true,
  });

  await prisma.shopOwner.createMany({
    data: [
      { userId: "4", shopId: "1" },
      { userId: "5", shopId: "2" },
    ],
    skipDuplicates: true,
  });
};
