package com.webprojectkotlin.preference

import android.content.Context

class AppPreference {
    fun setAccessToken(context: Context, accessToken: String?) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit()
        editor.putString(PreferenceHelp.access_token, accessToken)
        editor.apply()
    }
    fun setClearState(context: Context) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit();
        editor.clear();
        editor.commit();
    }

    fun getAccessToken(context: Context): String? {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(
            PreferenceHelp.access_token,
            ""
        )
    }

    fun setCurrentStatus(context: Context, currentStatus: String?) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit()
        editor.putString(PreferenceHelp.current_status, currentStatus)
        editor.apply()
    }

    fun getCurrentStatus(context: Context): String? {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(
            PreferenceHelp.current_status,
            ""
        )
    }

    fun setUsername(context: Context, username: String?) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit()
        editor.putString(PreferenceHelp.username, username)
        editor.apply()
    }

    fun getUsername(context: Context): String? {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(
            PreferenceHelp.username,
            ""
        )
    }

    fun setPan(context: Context, pan: String?) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit()
        editor.putString(PreferenceHelp.pan, pan)
        editor.apply()
    }

    fun getPan(context: Context): String? {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(
            PreferenceHelp.pan,
            ""
        )
    }

    fun setPhoneNo(context: Context, phoneNo: String?) {
        val preferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )
        val editor = preferences.edit()
        editor.putString(PreferenceHelp.phone_no, phoneNo)
        editor.apply()
    }

    fun getPhoneNo(context: Context): String? {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(
            PreferenceHelp.phone_no,
            ""
        )
    }

    companion object {
        const val PREF_NAME = "BNPL_PREFERENCES"
        var mAppPreferences: AppPreference? = null
        fun GetInstance(): AppPreference? {
            if (mAppPreferences == null) {
                mAppPreferences = AppPreference()
            }
            return mAppPreferences
        }
    }
}