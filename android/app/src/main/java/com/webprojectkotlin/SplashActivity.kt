package com.webprojectkotlin

import HttpUtils.post
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
import cz.msebera.android.httpclient.Header
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject


class SplashActivity : AppCompatActivity() {

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
        val userPhoneNumber = 0
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
        intent.putExtra("url", "https://redirect-staging.mandii.com/konnectbox");
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
        var m_Text = "+91";
        val builder: android.app.AlertDialog.Builder = android.app.AlertDialog.Builder(this)
        builder.setTitle("Enter Valid Phone Number")

// Set up the input
        val input = EditText(this)
// Specify the type of input expected; this, for example, sets the input as a password, and will mask the text
        input.setHint("+91 xxx xxx xxxx")
        input.maxLines = 1;
        input.inputType = InputType.TYPE_CLASS_NUMBER;
        input.setText(m_Text);
        builder.setView(input)
// Set up the buttons
        builder.setPositiveButton("OK", DialogInterface.OnClickListener { dialog, which ->
            // Here you get get input text from the Edittext
            Log.d("TEXT", m_Text);
//            m_Text = input.text.toString();
//            var m_Text = input.text.toString();
        })
        builder.setNegativeButton("Cancel", DialogInterface.OnClickListener { dialog, which -> dialog.cancel() })

        builder.show()
    }

    fun getCreateAccount() {
        val rp = RequestParams();
//        rp.add("");
//        rp.add("username", "aaa") rp . add "password", "aaa@123")

        post("/order", rp, object : JsonHttpResponseHandler() {
            override fun onSuccess(
                statusCode: Int,
                headers: Array<Header?>?,
                response: JSONObject
            ) {
                // If the response is JSONObject instead of expected JSONArray
                Log.d("asd", "---------------- this is response : $response")
                try {
                    val serverResp = JSONObject(response.toString())
                } catch (e: JSONException) {
                    // TODO Auto-generated catch block
                    e.printStackTrace()
                }
            }

            override fun onSuccess(
                statusCode: Int,
                headers: Array<Header?>?,
                timeline: JSONArray?
            ) {
                // Pull out the first event on the public timeline
            }
        })
    }
}
