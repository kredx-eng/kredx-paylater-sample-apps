package com.webprojectkotlin.activity

import android.Manifest
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.text.InputType
import android.util.Log
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.loopj.android.http.JsonHttpResponseHandler
import com.loopj.android.http.RequestParams
import com.webprojectkotlin.MainActivity
import com.webprojectkotlin.R
import com.webprojectkotlin.api.ApiRequest
import com.webprojectkotlin.preference.AppPreference
import cz.msebera.android.httpclient.Header
import cz.msebera.android.httpclient.entity.StringEntity
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.util.*


class SplashActivity : AppCompatActivity() {
    var phoneNumber = "+91";
    var PAN = "PAN";
    var permissionArrays = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.WRITE_EXTERNAL_STORAGE,
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.ACCESS_FINE_LOCATION,
        Manifest.permission.ACCESS_COARSE_LOCATION,
        Manifest.permission.RECORD_AUDIO,
    )
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        val btn_register =  findViewById(R.id.btn_register) as Button ///IN THIS LINE I AM GETTING THE ERROR
        val btn_payment=  findViewById(R.id.btn_payment) as Button ///IN THIS LINE I AM GETTING THE ERROR
        btn_register.setOnClickListener {
            checkPermission();
        }

        btn_payment.setOnClickListener {
            val intent= Intent(this, MainActivity::class.java);
            showdialog();
//            intent.putExtra("url", "https://bit.karza.in/s/6dg9tA6");
//            startActivity(intent);
        }
    }

    private fun openWebview() {
        val intent = Intent(this, MainActivity::class.java);
        intent.putExtra("url", "https://redirect-staging.mandii.com/ib");
        startActivity(intent);
    }

    private fun requestPermission() {
        val PERMISSION_REQUEST_CODE = 1;
        if (ActivityCompat.shouldShowRequestPermissionRationale(
                this@SplashActivity,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
        ) {


        } else {
            ActivityCompat.requestPermissions(
                this@SplashActivity,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                PERMISSION_REQUEST_CODE
            )
        }
    }


    fun hasPermissions(context: Context): Boolean = permissionArrays.all {
        ActivityCompat.checkSelfPermission(this@SplashActivity, it) == PackageManager.PERMISSION_GRANTED
    }


    private fun checkPermission() {
        val PERMISSION_REQUEST_CODE = 1;
        val permission = hasPermissions(this@SplashActivity);
        if(permission) openWebview();
        else  ActivityCompat.requestPermissions(
            this@SplashActivity,
            permissionArrays,
            PERMISSION_REQUEST_CODE
        )
         }

    fun showdialog(){
        val builder: android.app.AlertDialog.Builder = android.app.AlertDialog.Builder(this)
        builder.setTitle("Enter Valid Phone Number")

// Set up the input
        val input = EditText(this)
// Specify the type of input expected; this, for example, sets the input as a password, and will mask the text
        input.setHint("+91 xxx xxx xxxx")
        input.maxLines = 1;
        input.inputType = InputType.TYPE_CLASS_NUMBER;
        input.setText(phoneNumber);
        builder.setView(input)
// Set up the buttons
        builder.setPositiveButton("OK", DialogInterface.OnClickListener { dialog, which ->
            // Here you get get input text from the Edittext
            Log.d("TEXT", phoneNumber);
            getCreateOrder();
//            m_Text = input.text.toString();
//            var m_Text = input.text.toString();
        })
        builder.setNegativeButton("Cancel", DialogInterface.OnClickListener { dialog, which -> dialog.cancel() })

        builder.show()
    }

    fun getCreateOrder() {
        var phoneNo= AppPreference.GetInstance()!!.getPhoneNo(this@SplashActivity);
        var pan= AppPreference.GetInstance()!!.getPan(this@SplashActivity);
        var orderId =  (Random().nextInt(900000) + 100000).toString();
        var marchentId = "ABCD" + orderId;
        // val rp = RequestParams();
        var createOrderJObj = JSONObject();

        createOrderJObj.put("order_id", orderId);
        createOrderJObj.put("order_amount", "1000");
        createOrderJObj.put("merchant_order_number",  marchentId);
        createOrderJObj.put("order_description", "testing webview app");
        createOrderJObj.put("payment_confirmation_url", "https://facebook.com");
        createOrderJObj.put("payment_notification_api", "https://facebook.com");

        var customer_details = JSONObject();
        customer_details.put("first_name", "XYZ");
        customer_details.put("last_name", "Alpha");
        customer_details.put("email", "user@kredx.com");
        customer_details.put("phone", phoneNo);
        customer_details.put("company_pan", pan);
        createOrderJObj.put("customer_details", customer_details)

        var billing_address = JSONObject();
        billing_address.put("city", "bangalore");
        billing_address.put("state", "karanatak");
        billing_address.put("pincode", "530103");
        billing_address.put("address_line_1", "4545454");
        billing_address.put("address_line_2", "kredx");
        billing_address.put("name", "user");
        billing_address.put("phone", phoneNo);
        createOrderJObj.put("billing_address", billing_address)

        var shipping_address = JSONObject();
        shipping_address.put("city", "bangalore");
        shipping_address.put("state", "karanatak");
        shipping_address.put("pincode", "530103");
        shipping_address.put("address_line_1", "4545454");
        shipping_address.put("address_line_2", "kredx");
        shipping_address.put("name", "user");
        shipping_address.put("phone", phoneNo);

        createOrderJObj.put("shipping_address", shipping_address)

//        var orderLineJArray = JSONArray();
//        var order_line_object = JSONObject();
//        order_line_object.put("name", "user");
//        order_line_object.put("sku", "sku");
//        order_line_object.put("quantity", "0");
//        order_line_object.put("price", price.toString())
//        orderLineJArray[0]= order_line_object;

        var tax_amount = JSONObject();
        tax_amount.put("amount", "400");
        tax_amount.put("currency", "INR");
        createOrderJObj.put("tax_amount", tax_amount);

        var urls = JSONObject();
        urls.put("success", "https://www.facebook.com/login/");
        urls.put("failure", "https://www.facebook.com/login/");
        urls.put("cancel", "https://www.facebook.com/login/");
        urls.put("notification", "https://www.facebook.com/login/");
        createOrderJObj.put("urls", urls);

        var notes = JSONObject();
        notes.put("delivery_person_phone", "delivery_person_phone");
        createOrderJObj.put("notes", urls);

        var order_lines = JSONArray();
        var price = JSONObject();
        //val requestParams: RequestParams = JsonHelper.toRequestParams(params)
        val entity = StringEntity(createOrderJObj.toString())
        var accessToken = AppPreference.GetInstance()!!.getAccessToken(this@SplashActivity);
        ApiRequest.post(this, "/orders",accessToken.toString(), entity, object : JsonHttpResponseHandler() {
            override fun onSuccess(
                statusCode: Int,
                headers: Array<Header?>?,
                response: JSONObject
            ) {
                // If the response is JSONObject instead of expected JSONArray
                Log.d("onSuccess", "onSuccess : $response")
                try {
                    val serverResp = JSONObject(response.toString())
                } catch (e: JSONException) {
                    Log.e("api error", e.toString());
                    // TODO Auto-generated catch block
                    e.printStackTrace()
                }
            }

            override fun onFailure(
                statusCode: Int,
                headers: Array<out Header>?,
                responseString: String?,
                throwable: Throwable?
            ) {
                Log.d("onFailure", "onFailure : $responseString")
                try {
                } catch (e: JSONException) {
                    Log.e("api error", e.toString());
                    // TODO Auto-generated catch block
                    e.printStackTrace()
                }

            }

            override fun onSuccess(
                statusCode: Int,
                headers: Array<out Header>?,
                responseString: String?
            ) {
                Log.d("onSuccess String", "onSuccess : $responseString")
                super.onSuccess(statusCode, headers, responseString)
            }

            override fun onSuccess(
                statusCode: Int,
                headers: Array<out Header>?,
                response: JSONArray?
            ) {
                Log.d("onSuccess JSONArray", "onSuccess : $response")
                super.onSuccess(statusCode, headers, response)
            }
        })
    }
}
