<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class WelcomeUserMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(public User $user) {}

    public function build(): WelcomeUserMail
    {
        return $this->subject('Witamy użytkownika')
            ->view('emails.welcome')
            ->with(['user' => $this->user]);
    }
}
