<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create one user with first_name, last_name and phone
        $user = User::factory()->create([
            'first_name' => 'Test',
            'last_name'  => 'User',
            'phone'      => '+1234567890',
        ]);

        // Attach two emails to that user
        $user->emails()->createMany([
            ['email' => 'test@example.com'],
            ['email' => 'user@example.com'],
        ]);
    }
}
