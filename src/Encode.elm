port module Encode exposing (updateAudioGraph)

import Json.Encode exposing (Value, list, object, string, float, int)
import Lib exposing (..)


updateAudioGraph : AudioGraph -> Cmd msg
updateAudioGraph =
    renderContextJs << encodeGraph


port renderContextJs : Value -> Cmd msg


encodeGraph : AudioGraph -> Value
encodeGraph =
    object << List.map encodeNode


encodeNode : AudioNode -> ( String, Value )
encodeNode node =
    nodePatternMatch <|
        case node of
            Gain params edges ->
                ( params.id, "gain", edges, encodeGainParams params )

            Oscillator params edges ->
                ( params.id, "oscillator", edges, encodeOscillatorParams params )

            Filter params edges ->
                ( params.id, "biquadFilter", edges, encodeFilterParams params )

            Delay params edges ->
                ( params.id, "delay", edges, encodeDelayParams params )


nodePatternMatch : ( NodeId, String, NodeEdges, Value ) -> ( String, Value )
nodePatternMatch ( id, apiName, edges, encodedParams ) =
    -- matches virtual-audio-graph api
    ( toString id
    , list [ string apiName, encodeEdges edges, encodedParams ]
    )


encodeEdges : NodeEdges -> Value
encodeEdges =
    list << List.map encodeNodePort


encodeNodePort : NodePort NodeId -> Value
encodeNodePort nodePort =
    let
        keyDestObject id param =
            object
                [ ( "key", toStringValue id )
                , ( "destination", string param )
                ]
    in
        case nodePort of
            Output ->
                string "output"

            Input id ->
                toStringValue id

            Volume id ->
                keyDestObject id "gain"

            Frequency id ->
                keyDestObject id "frequency"

            Detune id ->
                keyDestObject id "detune"

            Q id ->
                keyDestObject id "q"

            DelayTime id ->
                keyDestObject id "delayTime"


encodeGainParams : GainParams -> Value
encodeGainParams node =
    object
        [ ( "gain", float node.volume ) ]


encodeOscillatorParams : OscillatorParams -> Value
encodeOscillatorParams node =
    object
        [ ( "type", toLowerStringValue node.waveform )
        , ( "frequency", float node.frequency )
        , ( "detune", float node.detune )
        ]


encodeFilterParams : BiquadFilterParams -> Value
encodeFilterParams node =
    object
        [ ( "type", toLowerStringValue node.mode )
        , ( "frequency", float node.frequency )
        , ( "Q", float node.q )
        , ( "detune", float node.detune )
        ]


encodeDelayParams : DelayParams -> Value
encodeDelayParams node =
    object
        [ ( "delayTime", float node.delayTime )
        , ( "maxDelayTime", float node.maxDelayTime )
        ]


toStringValue =
    string << toString


toLowerStringValue =
    string << String.toLower << toString
