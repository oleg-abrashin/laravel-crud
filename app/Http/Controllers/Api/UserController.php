<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use App\Mail\WelcomeUserMail;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class UserController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(User::with('emails')->get());
    }

    public function store(StoreUserRequest $request): JsonResponse
    {
        $user = User::create($request->only('first_name', 'last_name', 'phone'));
        if ($request->has('emails')) {
            $user->emails()->createMany(
                collect($request->emails)->map(fn($email) => ['email' => $email])->toArray()
            );
        }
        return response()->json($user->load('emails'), 201);
    }

    public function show(User $user): JsonResponse
    {
        return response()->json($user->load('emails'));
    }

    public function update(UpdateUserRequest $request, User $user): JsonResponse
    {
        $user->update($request->only('first_name', 'last_name', 'phone'));

        if ($request->has('emails')) {
            $user->emails()->delete();
            $user->emails()->createMany(
                collect($request->emails)->map(fn($email) => ['email' => $email])->toArray()
            );
        }

        return response()->json($user->load('emails'));
    }

    public function destroy(User $user): JsonResponse
    {
        $user->delete();
        return response()->json(null, 204);
    }

    public function sendWelcomeMail(User $user): JsonResponse
    {
        foreach ($user->emails as $email) {
            Mail::to($email->email)->send(new WelcomeUserMail($user));
        }

        return response()->json(['message' => 'Emails sent']);
    }
}

