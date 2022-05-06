package com.idmtest;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;
import androidx.annotation.Nullable;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.idmission.client.IdType;
import com.idmission.client.ImageProcessingResponseListener;
import com.idmission.client.ImageProcessingSDK;
import com.idmission.client.ImageType;
import com.idmission.client.RequestResponseInterface;
import com.idmission.client.Response;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

public class IDMissionSDK extends ReactContextBaseJavaModule implements ImageProcessingResponseListener, RequestResponseInterface {

    private ImageProcessingSDK imageProcessingSDK = null;
    private static final String FINGER_FOCUS_RATIO = "FINGER_FOCUS_RATIO", FINGER_GLARE_THRESHOLD = "FINGER_GLARE_THRESHOLD", FINGER_TO_CHECK_FOCUS = "FINGER_TO_CHECK_FOCUS",
            INDEX_FINGER_THRESHOLD = "mINDEX_FINGER_THRESHOLD", MIDDLE_FINGER_THRESHOLD = "mMIDDLE_FINGER_THRESHOLD", RING_FINGER_THRESHOLD = "mRING_FINGER_THRESHOLD", BABY_FINGER_THRESHOLD = "mBABY_FINGER_THRESHOLD",
            INDEX_FINGER_THRESHOLD_MIN = "mINDEX_FINGER_THRESHOLD_MIN", MIDDLE_FINGER_THRESHOLD_MIN = "mMIDDLE_FINGER_THRESHOLD_MIN", RING_FINGER_THRESHOLD_MIN = "mRING_FINGER_THRESHOLD_MIN", BABY_FINGER_THRESHOLD_MIN = "mBABY_FINGER_THRESHOLD_MIN",
            SAVE_IMAGE_WIDTH_4F = "SAVE_IMAGE_WIDTH_4F", AGGRESSIVENESS_FACTOR = "AGGRESSIVENESS_FACTOR", ZOOM_CAMERA = "ZOOM_CAMERA", RIDGE_WIDTH = "RIDGE_WIDTH", FINGER_LENGTH_PERCENTAGE = "FINGER_LENGTH_PERCENTAGE", SHARP_THRESHOLD = "SHARP_THRESHOLD", FINGER_WIDTH_AV_COUNTER = "FINGER_WIDTH_AV_COUNTER", HAND_TYPE_LEFT = "HAND_TYPE_LEFT", FP_INSTRUCTION_BTN_COLOR = "FP_INSTRUCTION_BTN_COLOR", FP_INSTRUCTION_BTN_ALPHA = "FP_INSTRUCTION_BTN_ALPHA",
            FP_INSTRUCTION_BTN_TXT_COLOR = "FP_INSTRUCTION_BTN_TXT_COLOR", FP_INSTRUCTION_BTN_TXT_ALPHA = "FP_INSTRUCTION_BTN_TXT_ALPHA", TEXT_FONT_TYPE_FP = "TEXT_FONT_TYPE_FP", TEXT_FONT_STYLE_FP = "TEXT_FONT_STYLE_FP", TEXT_LABEL_COLOR_FP = "TEXT_LABEL_COLOR_FP", TEXT_LABEL_ALPHA_FP = "TEXT_LABEL_ALPHA_FP", SHOW_INSTRUCTION_SCREEN = "SHOW_INSTRUCTION_SCREEN",
            INDEX_CAPTURE="INDEX_CAPTURE", MIDDLE_CAPTURE="MIDDLE_CAPTURE", RING_CAPTURE="RING_CAPTURE", BABY_CAPTURE="BABY_CAPTURE", PROCESS_ONLY_INDEX_CAPTURE="PROCESS_ONLY_INDEX_CAPTURE", PROCESS_ONLY_MIDDLE_CAPTURE="PROCESS_ONLY_MIDDLE_CAPTURE", PROCESS_ONLY_RING_CAPTURE="PROCESS_ONLY_RING_CAPTURE", PROCESS_ONLY_BABY_CAPTURE="PROCESS_ONLY_BABY_CAPTURE", PROCESS_CAPTURED_FRAME="PROCESS_CAPTURED_FRAME", INITIAL_FRAME_HEIGHT="INITIAL_FRAME_HEIGHT", MASK_UNWANTED_PART="MASK_UNWANTED_PART", FAR_PERCENTAGE = "FAR_PERCENTAGE", TOO_FAR_PERCENTAGE = "TOO_FAR_PERCENTAGE";

    //constructor
    public IDMissionSDK(ReactApplicationContext reactContext) {
        super(reactContext);
    }
    @Override
    public String getName() {
        return "IDMissionSDK";
    }

    @ReactMethod
    public void  initializeSDK(String url, String loginID, String password, String merchantID, Integer productID, String productName, String language) {
        try {
            imageProcessingSDK  =   ImageProcessingSDK.initialize(getReactApplicationContext().getCurrentActivity(), url, loginID, password, merchantID, productID, productName, language,false);
            imageProcessingSDK.setImageProcessingResponseListener(this);

            WritableMap params = Arguments.createMap();
            try{
                params.putString("data", "SDK Initialized Successfully");
            }catch(Exception e){}
            sendEvent(getReactApplicationContext(), "DataCallback", params);
        } catch (Exception exception) {
            Log.e("expection",exception.getMessage());
            WritableMap params = Arguments.createMap();
            try{
                params.putString("data", "Exception");
            }catch(Exception e){}
            sendEvent(getReactApplicationContext(), "DataCallback", params);
        }
    }

    @ReactMethod
    public void customizeUserInterface(String uiconfiguration) {
        try {

            JSONObject uiconfigurationJSONObject = new JSONObject(uiconfiguration);

            ImageProcessingSDK.getInstance().customizeUserInterface(uiconfigurationJSONObject);

        }
        catch (Exception e)
        {
            Log.e("expection",e.getMessage());
        }
    }

    @ReactMethod
    public void detectFace(String faceCaptureConfig, String uiConfigDictionary) {
        try {

            JSONObject faceCaptureConfigJSONObject = new JSONObject(faceCaptureConfig);
            JSONObject uiConfigDictionaryJSONObject = new JSONObject(uiConfigDictionary);

            ImageProcessingSDK.getInstance().detectFace(getCurrentActivity(), faceCaptureConfigJSONObject, uiConfigDictionaryJSONObject);

        }
        catch (Exception e)
        {
            Log.e("expection",e.getMessage());
        }
    }

    @ReactMethod
    public void  captureIDFront(String additionalDictionary, String uiConfigDictionary) {
        try {

            JSONObject additionalDictionaryJSONObject = new JSONObject(additionalDictionary);
            JSONObject uiConfigDictionaryJSONObject = new JSONObject(uiConfigDictionary);
            ImageProcessingSDK.getInstance().autoCapture(getCurrentActivity(), ImageType.FRONT, uiConfigDictionaryJSONObject, additionalDictionaryJSONObject, null);
        }
        catch (Exception e)
        {
            Log.e("expection",e.getMessage());
        }
    }

    @ReactMethod
    public void  captureIDBack(String additionalDictionary, String uiConfigDictionary) {
        try {

            JSONObject additionalDictionaryJSONObject = new JSONObject(additionalDictionary);
            JSONObject uiConfigDictionaryJSONObject = new JSONObject(uiConfigDictionary);
            ImageProcessingSDK.getInstance().autoCapture(getCurrentActivity(), ImageType.BACK, uiConfigDictionaryJSONObject, additionalDictionaryJSONObject, null);
        }
        catch (Exception e)
        {
            Log.e("expection",e.getMessage());
        }
    }

    @ReactMethod
    public void  processImageAndMatchFace(String countryCode, String stateCode, String idType, String additionalDictionary) {
        try {
            JSONObject additionalDictionaryJSONObject = new JSONObject(additionalDictionary);

            IdType idTypes = IdType.PASSPORT;
            if(null!=idType && !idType.isEmpty()){
                if(idType.equals("PP")){
                    idTypes = IdType.PASSPORT;
                }else if(idType.equals("NID")){
                    idTypes = IdType.NATIONAL_ID;
                }else if(idType.equals("RID")){
                    idTypes = IdType.RESIDENCE_CARD;
                }else if(idType.equals("DL")){
                    idTypes = IdType.DRIVERS_LICENSE;
                }else if(idType.equals("PID")){
                    idTypes = IdType.PHOTO_ID_CARD;
                }else if(idType.equals("VID")){
                    idTypes = IdType.VOTER_ID_CARD;
                }else if(idType.equals("TID")){
                    idTypes = IdType.TAX_ID_CARD;
                }else if(idType.equals("WV")){
                    idTypes = IdType.WORK_VISA_PERMIT;
                }else if(idType.equals("SV")){
                    idTypes = IdType.STUDENT_VISA_PERMIT;
                }else if(idType.equals("GID")){
                    idTypes = IdType.MILITARY_POLICE_GOVERNMENT_ID;
                }else if(idType.equals("BID")){
                    idTypes = IdType.BOAT_SHIP_ID_CARD;
                }else if(idType.equals("IDM")){
                    idTypes = IdType.IDM;
                }else if(idType.equals("UBL")){
                    idTypes = IdType.UTILITY_BILL;
                }else if(idType.equals("OTH")){
                    idTypes = IdType.OTHERS;
                }
            }

            ImageProcessingSDK.getInstance().setImageProcessingResponseListener(IDMissionSDK.this);
            ImageProcessingSDK.getInstance().processImageAndMatchFace(getCurrentActivity(), countryCode, stateCode, idTypes, "FACE", additionalDictionaryJSONObject, true, true);
        }
        catch(Exception e)
        {
            Log.e("expection",e.getMessage());
        }
    }

    public  HashMap<String,String> jsonToMap(String t) throws JSONException {

        HashMap<String, String> map = new HashMap<String, String>();
        JSONObject jObject = new JSONObject(t);
        Iterator<?> keys = jObject.keys();

        while( keys.hasNext() ){
            String key = (String)keys.next();
            String value = jObject.getString(key);
            map.put(key, value);
        }
        return  map;
    }

    @ReactMethod
    public void  TestMethod(String message) {
        Toast.makeText(getReactApplicationContext(), message, Toast.LENGTH_SHORT).show();
    }

    private void sendEvent(ReactContext reactContext,
                           String eventName,
                           @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    @Override
    public void onImageProcessingResultAvailable(Map<String, String> map, Response response) {
        Log.e("map111",map.toString());
    }

    @Override
    public void onAutoImageCaptureResultAvailable(Map<String, String> map, Response response) {
        WritableMap params = Arguments.createMap();
        params.putInt("statusCode", response.getStatusCode());
        params.putString("statusMessage", response.getStatusMessage());
        String image = "";

        if(map.containsKey("FRONT")) {
            image = map.get("FRONT");
            if(image !=null) {
                try {
                    params.putString("front", resizeBase64Image(image));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        else if(map.containsKey("BACK")){
            image = map.get("BACK");
            if(image !=null) {
                try {
                    params.putString("back", resizeBase64Image(image));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        else
        {
            image = map.get("GENERIC");
            if(image !=null) {
                try {
                    params.putString("generic", resizeBase64Image(image));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        sendEvent(getReactApplicationContext(), "DataCallback", params);
    }

    @Override
    public void onAutoFillResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onAutoFillFieldInformationAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onFaceDetectionResultAvailable(Map<String, String> map, Response response) {
        WritableMap params = Arguments.createMap();
        params.putInt("statusCode", response.getStatusCode());
        params.putString("statusMessage", response.getStatusMessage());

        String image="";
        if(map.containsKey("FACE")) {
            image = map.get("FACE");
            if(image!=null) {
                try {
                    params.putString("face", image);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        sendEvent(getReactApplicationContext(), "DataCallback", params);
    }

    @Override
    public void onFaceMatchingResultAvailable(Map<String, String> map, Response response) {
        Log.e("map11",map.toString());
    }

    @Override
    public void onCardDetectionResultAvailable(Map<String, String> map, Response response) {
        Log.d("gps",map.toString());
    }

    @Override
    public void onCaptureProofOfAddressResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onCaptureBankStatementResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onCaptureGenericDocumentResultAvailable(Map<String, String> map, Response response) {
        Log.e("generic",map.toString());
    }

    @Override
    public void onCaptureBirthCertificateResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onImageProcessingAndFaceMatchingResultAvailable(Map<String, String> map, Response response) {
        WritableMap params = Arguments.createMap();
        params.putInt("statusCode", response.getStatusCode());
        params.putString("statusMessage", response.getStatusMessage());

        if(map.containsKey("Redacted_Front_Image")){
            map.remove("Redacted_Front_Image");
        }
        if(map.containsKey("Redacted_Back_Image")){
            map.remove("Redacted_Back_Image");
        }
        if(map.containsKey("Match_Found_Against")){
            map.remove("Match_Found_Against");
        }
        if(map.containsKey("CustomerPhoto")){
            map.remove("CustomerPhoto");
        }
        if(map.containsKey("Customer_Photo_for_Face_Matching")){
            map.remove("Customer_Photo_for_Face_Matching");
        }

        try{
            params.putString("data", map.toString());
        }catch(Exception e){}
        sendEvent(getReactApplicationContext(), "DataCallback", params);
    }

    @Override
    public void onOperationResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onCustomerVerificationResultAvailable(Map<String, String> map, Response response) {
        Log.d("verify",map.toString());
    }

    @Override
    public void onCustomizeUserInterfaceResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onVoiceRecordingFinished(Map<String, String> map, Response response) {
        Log.e("gps coordinates", map + "data");
    }

    @Override
    public void onGPSCoordinateAvailable(Map<String, String> map, Response response) {
        Log.e("gps coordinates", map + "data");
    }

    @Override
    public void onFourFingerCaptureFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onFingerprintCaptureFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onFingerprintEnrolmentFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onFingerprintVerificationFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onVideoRecordingFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onScanBarcodeFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onCaptureSignatureFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onVerifyAddressFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onCreateEmployeeFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onVerifyEmployeeFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onGenerateTokenFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onVerifyTokenFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onSnippetImageCaptureResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onUpdateCustomerFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onGenerateOTPFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onVerifyOTPFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onInitializationResultAvailable(Map<String, String> map, Response response) {
        Log.e(response.getStatusCode()+"",response.getStatusMessage());

    }

    @Override
    public void onExecuteCustomProductCall(Map<String, String> map, Response response) {

    }

    @Override
    public void onUpdateEmployeeFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onIDValidationAndVideoMatchingFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void genericApiCallResponse(Map<String, String> map, Response response) {

    }

    @Override
    public void onVideoConferencingFinished(Map<String, String> map, Response response) {

    }

    @Override
    public void onDownloadXsltResultAvailable(Map<String, String> map, Response response) {

    }

    @Override
    public void onDownloadCountryResultAvailable(LinkedHashMap<String, String> linkedHashMap, Response response) {

    }

    @Override
    public void onDownloadStateResultAvailable(LinkedHashMap<String, String> linkedHashMap, Response response) {

    }

    @Override
    public void cancelPogressBar() {

    }

    public String resizeBase64Image(String base64image){
        try{
            byte [] encodeByte=Base64.decode(base64image.getBytes(),Base64.DEFAULT);
            BitmapFactory.Options options=new BitmapFactory.Options();
            options.inPurgeable = true;
            Bitmap image = BitmapFactory.decodeByteArray(encodeByte, 0, encodeByte.length,options);

            ByteArrayOutputStream baos=new  ByteArrayOutputStream();
            image.compress(Bitmap.CompressFormat.JPEG,70, baos);

            byte [] b=baos.toByteArray();
            System.gc();
            return Base64.encodeToString(b, Base64.NO_WRAP);
        }catch(Exception e){
            e.printStackTrace();
            return base64image;
        }
    }
}
