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
var login_id = "";
var password = "";
var merchant_id = "";
var product_id = 0;
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

    onDetectFace = () => {
        IDMissionSDK.detectFace();
    }

    onCaptureIDFront = () => {
        IDMissionSDK.captureIDFront("USA", "PP");
    }
         
    onCaptureIDBack = () => {
        IDMissionSDK.captureIDBack("USA", "PP");
    }
	
	onProcessImageAndMatchFace = () => {
        IDMissionSDK.processImageAndMatchFace("USA", "PP");
    }

    render() {
        return (
            <Container>
			
                <Content contentContainerStyle={{ justifyContent: 'center' }}>
				    
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
