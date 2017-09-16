module Lib exposing (..)


type alias AudioGraph =
    List AudioNode


type AudioNode
    = Gain GainParams NodeEdges
    | Osc OscillatorParams NodeEdges
    | Filter BiquadFilterParams NodeEdges
    | Delay DelayParams NodeEdges


type alias NodeEdges =
    List (NodePort NodeId)


type alias NodeId =
    Int


type AudioInput
    = AudioInput


type Waveform
    = Sine
    | Square
    | Sawtooth
    | Triangle


type FilterMode
    = Lowpass
    | Highpass
    | Bandpass
    | Lowshelf
    | Highshelf
    | Peaking
    | Notch
    | Allpass



-------- Node Constructors --------


{-| <https://developer.mozilla.org/en-US/docs/Web/API/GainNode>
-}
type alias GainDefaults =
    { volume : Float
    }


gainDefaults : GainDefaults
gainDefaults =
    { volume = 1
    }


type alias GainParams =
    { id : NodeId
    , input : AudioInput
    , volume : Float
    }


gainParams : NodeId -> GainDefaults -> GainParams
gainParams id defaults =
    { id = id
    , input = AudioInput
    , volume = defaults.volume
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/OscillatorNode>
-}
type alias OscillatorDefaults =
    { waveform : Waveform
    , frequency : Float
    , detune : Float
    }


oscDefaults : OscillatorDefaults
oscDefaults =
    { waveform = Sine
    , frequency = 440
    , detune = 0
    }


type alias OscillatorParams =
    { id : NodeId
    , waveform : Waveform
    , frequency : Float
    , detune : Float
    }


oscParams : NodeId -> OscillatorDefaults -> OscillatorParams
oscParams id defaults =
    { id = id
    , waveform = defaults.waveform
    , frequency = defaults.frequency
    , detune = defaults.detune
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/BiquadFilterNode>
-}
type alias BiquadFilterDefaults =
    { mode : FilterMode
    , frequency : Float
    , q : Float
    , detune : Float
    }


filterDefaults : BiquadFilterDefaults
filterDefaults =
    { mode = Lowpass
    , frequency = 350
    , q = 1
    , detune = 0
    }


type alias BiquadFilterParams =
    { id : NodeId
    , input : AudioInput
    , mode : FilterMode
    , frequency : Float
    , q : Float
    , detune : Float
    }


filterParams : NodeId -> BiquadFilterDefaults -> BiquadFilterParams
filterParams id defaults =
    { id = id
    , input = AudioInput
    , mode = defaults.mode
    , frequency = defaults.frequency
    , q = defaults.q
    , detune = defaults.detune
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/DelayNode>
-}
type alias DelayDefaults =
    { delayTime : Float
    , maxDelayTime : Float
    }


delayDefaults : DelayDefaults
delayDefaults =
    { delayTime = 0
    , maxDelayTime = 0
    }


type alias DelayParams =
    { id : NodeId
    , delayTime : Float
    , maxDelayTime : Float
    }


delayParams : NodeId -> DelayDefaults -> DelayParams
delayParams id defaults =
    { id = id
    , delayTime = 0
    , maxDelayTime = 0
    }



-------- Param Ports --------


type NodePort id
    = Output
    | Input id
    | Volume id
    | Frequency id
    | Detune id
    | Q id
    | DelayTime id


input : { a | input : AudioInput, id : NodeId } -> NodePort NodeId
input a =
    Input a.id


volume : { a | volume : Float, id : NodeId } -> NodePort NodeId
volume a =
    Volume a.id


frequency : { a | frequency : Float, id : NodeId } -> NodePort NodeId
frequency a =
    Frequency a.id


detune : { a | detune : Float, id : NodeId } -> NodePort NodeId
detune a =
    Detune a.id


q : { a | q : Float, id : NodeId } -> NodePort NodeId
q a =
    Q a.id


delayTime : { a | delayTime : Float, id : NodeId } -> NodePort NodeId
delayTime a =
    DelayTime a.id
