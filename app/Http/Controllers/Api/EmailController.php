<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Email;
use Illuminate\Http\Request;

class EmailController extends Controller
{
    public function destroy(Email $email): \Illuminate\Http\JsonResponse
    {
        $email->delete();
        return response()->json(null, 204);
    }
}
