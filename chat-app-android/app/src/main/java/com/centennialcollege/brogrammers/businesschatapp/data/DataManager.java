package com.centennialcollege.brogrammers.businesschatapp.data;

import android.support.annotation.NonNull;

import com.centennialcollege.brogrammers.businesschatapp.data.remote.FirebaseAuthExceptions;
import com.centennialcollege.brogrammers.businesschatapp.data.remote.FirebaseAuthHelper;
import com.centennialcollege.brogrammers.businesschatapp.data.remote.FirebaseDbHelper;
import com.centennialcollege.brogrammers.businesschatapp.model.User;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;

public interface DataManager {

    @NonNull
    FirebaseAuthExceptions getFirebaseException(Exception e);

    FirebaseAuthHelper getFirebaseAuthHelper();

    FirebaseDbHelper getFirebaseDbHelper();

    Task<Void> createUser(User user, String password);

    Task<AuthResult> signIn(String email, String password);

}