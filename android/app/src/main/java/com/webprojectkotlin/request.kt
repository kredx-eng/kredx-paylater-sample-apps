import android.util.Log
import com.loopj.android.http.AsyncHttpClient
import com.loopj.android.http.AsyncHttpResponseHandler
import com.loopj.android.http.RequestParams
import cz.msebera.android.httpclient.HttpEntity
import cz.msebera.android.httpclient.HttpResponse
import cz.msebera.android.httpclient.client.ClientProtocolException
import cz.msebera.android.httpclient.client.HttpClient
import cz.msebera.android.httpclient.client.methods.HttpPatch
import cz.msebera.android.httpclient.entity.StringEntity
import cz.msebera.android.httpclient.impl.client.DefaultHttpClient
import cz.msebera.android.httpclient.util.EntityUtils
import java.io.IOException
import java.io.UnsupportedEncodingException

var accessToken = "";

object HttpUtils {
    private const val BASE_URL = "https://staging.mandii.com/bnpl/v1/";
    private val client: AsyncHttpClient = AsyncHttpClient()
    operator fun get(
        url: String,
        params: RequestParams?,
        responseHandler: AsyncHttpResponseHandler?
    ) {
        client.get(getAbsoluteUrl(url), params, responseHandler)
    }

    fun post(url: String, params: RequestParams?, responseHandler: AsyncHttpResponseHandler?) {
        client.post(getAbsoluteUrl(url), params, responseHandler)
    }

    fun getByUrl(url: String?, params: RequestParams?, responseHandler: AsyncHttpResponseHandler?) {
        client.get(url, params, responseHandler)
    }

    fun postByUrl(
        url: String?,
        params: RequestParams?,
        responseHandler: AsyncHttpResponseHandler?
    ) {
        client.post(url, params, responseHandler)
    }

    private fun getAbsoluteUrl(relativeUrl: String): String {
        return BASE_URL + relativeUrl
    }
}

fun makeRequest(uri: String?, json: String?): HttpResponse? {
    try {
        val httpclient: HttpClient = DefaultHttpClient()
        val httpPatch = HttpPatch(uri) // create new httpGet object
        httpPatch.setHeader("Authorization", getAccessToken())
        httpPatch.setEntity(StringEntity(json))
        httpPatch.setHeader("Content-Type", "application/json; charset=utf-8")
        val response: HttpResponse = httpclient.execute(httpPatch)
        val entity: HttpEntity = response.getEntity()
        var resCoupon = EntityUtils.toString(entity);
        Log.d("requestride", resCoupon)
        return DefaultHttpClient().execute(httpPatch)
    } catch (e: UnsupportedEncodingException) {
        e.printStackTrace()
    } catch (e: ClientProtocolException) {
        e.printStackTrace()
    } catch (e: IOException) {
        e.printStackTrace()
    }
    return null
}

@JvmName("setAccessToken1")
fun setAccessToken(tkn: String?): String {
    if (tkn != null) {
        accessToken = tkn;
    };
    return "";
}

@JvmName("getAccessToken1")
fun getAccessToken(): String? {
    return ""
}
