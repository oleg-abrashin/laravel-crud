<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'first_name' => ['sometimes', 'string', 'max:255'],
            'last_name'  => ['sometimes', 'string', 'max:255'],
            'phone'      => ['nullable', 'string'],
            'emails'     => ['nullable', 'array'],
            'emails.*'   => ['required_with:emails', 'email'],
        ];
    }
}

