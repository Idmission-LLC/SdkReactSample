import React from 'react'
import { View, TouchableOpacity, Text, Image, Platform } from 'react-native'
import { Container, Header, Content, Picker } from "native-base";
import * as constant from '../Constant'
import styles from '../Styles'
import { NativeModules, NativeEventEmitter } from 'react-native';
import { TextInput } from "react-native";
import { LogBox } from 'react-native';

LogBox.ignoreLogs(['new NativeEventEmitter']);
LogBox.ignoreLogs(['Warning: ...']);
LogBox.ignoreAllLogs(); 
const { IDMissionSDK } = NativeModules;

var url = "https://demo.idmission.com/IDS/service/integ/idm/thirdparty/upsert";
var login_id = "showcase_integ";
var password = "Merchant#2";
var merchant_id = "12511";
var product_id = 4130;
var product_name = "Identity_Validation_and_Face_Matching";

export default class Home extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            selected: '',
            images: '',
            uniqueCustomerNumber: '',
            event: [
                "Select Feature"
            ]
        }
    }

    componentDidMount() {

        IDMissionSDK.initializeSDK(
            url,
            login_id,
            password,
            merchant_id,
            product_id,
            product_name,
            "en",
        );

        const eventEmitter = new NativeEventEmitter(IDMissionSDK);

        eventEmitter.addListener('onSessionConnect', (event) => { });

        eventEmitter.addListener('DataCallback', (event) => {
            console.log("Response")
            this.props.navigation.navigate("ResultScreen", { eventResponse: event, eventName: "Data" })
        });

    }

    onCustomizeUserInterface = () => {
        var uiconfiguration = {}; 

        IDMissionSDK.customizeUserInterface(JSON.stringify(uiconfiguration));
    }

    onDetectFace = () => {
        var faceCaptureConfig = {}; 
        var uiConfigDictionary = {};

        IDMissionSDK.detectFace(JSON.stringify(faceCaptureConfig), JSON.stringify(uiConfigDictionary));
    }

    onCaptureIDFront = () => {
        var additionalDictionary = {};
        var uiConfigDictionary = {
            "country_code" : "AUS",
            "id_country" : "AUS",
            "state_code" : "NS",
            "id_state" : "NS",
            "id_type" : "DL",
            "id_capture_portrait" : "Y",
            "id_image_height" : "1170",
            "id_image_width" : "800",
        };

        IDMissionSDK.captureIDFront(JSON.stringify(additionalDictionary), JSON.stringify(uiConfigDictionary));
    }
         
    onCaptureIDBack = () => {
        var additionalDictionary = {};
        var uiConfigDictionary = {
            "country_code" : "AUS",
            "id_country" : "AUS",
            "state_code" : "NS",
            "id_state" : "NS",
            "id_type" : "DL",
            "id_capture_portrait" : "Y",
            "id_image_height" : "1170",
            "id_image_width" : "800",
        };

        IDMissionSDK.captureIDBack(JSON.stringify(additionalDictionary), JSON.stringify(uiConfigDictionary));
    }
	
	onProcessImageAndMatchFace = () => {
        var countryCode = "AUS";
        var stateCode = "NS";
        var idType = "DL";

        var additionalDictionary = {
            "Manual_Review_Required" : "N",
            "Bypass_Age_Validation" : "N",
            "Bypass_Name_Matching" : "N",
            "Deduplication_Required" : "N",
            "Need_Immediate_Response" : "N",
            "POST_Data_API_Required" : "N",
            "Send_Input_Images_in_POST" : "N",
            "Send_Processed_Images_in_POST" : "N",
            "Capture_Secondary_ID" : "N",
            "Deduplication_Manual_Review_Required" : "N",
            "ID_Back_Image_Required" : "N",
            "Verify_Data_With_Host" : "N",
            "Service_ID" : "10"                        
        };

        IDMissionSDK.processImageAndMatchFace(countryCode, stateCode, idType, JSON.stringify(additionalDictionary));
    }

    render() {
        return (
            <Container>
			
                <Content contentContainerStyle={{ justifyContent: 'center' }}>

                    <TouchableOpacity style={styles.startButton} onPress={() => { this.onCustomizeUserInterface() }}>
                        <Text style={styles.startButtonText}>Customize User Interface</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.startButton} onPress={() => { this.onDetectFace() }}>
                        <Text style={styles.startButtonText}>Detect Face</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.startButton} onPress={() => { this.onCaptureIDFront() }}>
                        <Text style={styles.startButtonText}>Capture ID Front</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.startButton} onPress={() => { this.onCaptureIDBack() }}>
                        <Text style={styles.startButtonText}>Capture ID Back</Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.startButton} onPress={() => { this.onProcessImageAndMatchFace() }}>
                        <Text style={styles.startButtonText}>Process Image and Match Face</Text>
                    </TouchableOpacity>

                </Content>
            </Container>
        )
    }
}
