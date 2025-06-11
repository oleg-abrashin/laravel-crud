<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_be_created_with_emails()
    {
        $payload = [
            'first_name' => 'John',
            'last_name'  => 'Doe',
            'phone'      => '+48123456789',
            'emails'     => ['john@example.com', 'doe@example.com'],
        ];

        $response = $this->postJson('/api/users', $payload);
        $response->assertCreated()
            ->assertJsonFragment(['first_name' => 'John'])
            ->assertJsonCount(2, 'emails');
    }
}
