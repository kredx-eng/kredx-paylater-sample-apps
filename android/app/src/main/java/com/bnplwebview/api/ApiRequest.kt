package com.bnplwebview.api

import android.content.Context
import com.loopj.android.http.AsyncHttpClient
import com.loopj.android.http.AsyncHttpResponseHandler
import com.loopj.android.http.RequestParams
import cz.msebera.android.httpclient.entity.StringEntity


object ApiRequest {
    private const val BASE_URL = "https://staging.mandii.com/bnpl/v1/";
    private val client: AsyncHttpClient = AsyncHttpClient();
    operator fun get(
        url: String,
        params: RequestParams?,
        responseHandler: AsyncHttpResponseHandler?
    ) {
        client.get(getAbsoluteUrl(url), params, responseHandler)
    }

    fun post(context: Context, url: String, token: String, params: StringEntity?, responseHandler: AsyncHttpResponseHandler?) {
        client.addHeader("Authorization", "Bearer " + token)
        client.post(context, getAbsoluteUrl(url), params,"application/json", responseHandler)
    }

    fun getByUrl(url: String?, params: RequestParams?, responseHandler: AsyncHttpResponseHandler?) {
        client.get(url, params, responseHandler)
    }

    fun postByUrl(
        url: String?,token: String,
        params: RequestParams?,
        responseHandler: AsyncHttpResponseHandler?
    ) {
        client.addHeader("Authorization", "Bearer " + token)
        client.post( getAbsoluteUrl(url!!), params, responseHandler)
    }

    private fun getAbsoluteUrl(relativeUrl: String): String {
        return BASE_URL + relativeUrl
    }
}


