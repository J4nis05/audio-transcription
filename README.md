Transcribo
===

> Transcribe any audio or video file. 
> 
> Edit and view your transcripts in a standalone HTML editor.


Fork of [machinelearningZH/audio-transcription](https://github.com/machinelearningZH/audio-transcription).


![GitHub License](https://img.shields.io/github/license/machinelearningzh/audio-transcription)
[![PyPI - Python](https://img.shields.io/badge/python-v3.10+-blue.svg)](https://github.com/machinelearningZH/audio-transcription)


---


<img src="_img/ui1.PNG" alt="editor" width="1000"/>


<details>
<summary>Contents</summary>

- [Setup Instructions](#setup-instructions)
    - [Hardware requirements](#hardware-requirements)
    - [Installation](#installation)
    - [Running the Application](#running-the-application)
    - [Configuration](#configuration)
- [Project Information](#project-information)
    - [What does the application do?](#what-does-the-application-do)
- [Project team](#project-team)
- [Feedback and Contributions](#feedback-and-contributions)
- [Disclaimer](#disclaimer)
</details>


---


01 - Setup
---

> This will Focus mostly on the Installation on Docker.
> 
> Installation for Windows or Linux Is documented in the Original Repository

### 01.01 - Hardware Requirements

* Nvidia **CUDA-Compatible** GPU or a powerful enough CPU
  * [Nvidia - CUDA GPUs](https://developer.nvidia.com/cuda-gpus)
* GPU with at least 8 GB, or the recommended **16 GB VRAM**
* Up to date Docker Installation
  * Docker Desktop on Windows **must use WSL 2**, otherwise it won't work


### 01.02 - Hugging Face Access Token

* Login or Create an Account: [Hugging Face - Signup](https://huggingface.co/join)
* Accept the Conditions for These Repositories (Company Name, Website & Use Case are Required)
  * [pyannote/segmentation](https://huggingface.co/pyannote/segmentation)
  * [pyannote/speaker-diarization-3.0](https://huggingface.co/pyannote/speaker-diarization)
* Create a New Token with Write Access: [hf.co/settings/tokens](https://huggingface.co/settings/tokens/new?tokenType=write)
  * Save this token for later use in the `.env` Configuration File


### 01.03 - (Optional) Creating the SSL Certificate

Using HTTPS Requires a Certificate and Key File in the `.pem` Format.
More Information Can be Found in the Nicegui Documentation:
[Nicegui - Configuration & Deployment](https://nicegui.io/documentation/section_configuration_deployment#server_hosting)

This Script can be used to automatically Generate a Certificate: [ssl/certificate.sh](./ssl/certificate.sh)

1. Install OpenSSL

```bash
sudo apt update && sudo apt install openssl -y
```

2. Generate the Private Key

```bash
openssl genrsa -out key.pem 2048
```

3. Create a Certificate Signing Request

```bash
openssl req -new -key key.pem -out cert.csr
```

4. Generate the Self-Signed Certificate

```bash
openssl x509 -req -days 365 -in cert.csr -signkey key.pem -out cert.pem
```


### 01.04 - Creating the `.env` Configuration

This is an Example for a CUDA-Compatible GPU with at least 16 GB VRAM.

To disable SSL, replace the paths in `SSL_CERTFILE` and `SSL_KEYFILE` with Empty Strings: `""` 

With this Config the Server will be available at [`https://<server>:8080`](https://localhost:8080).

```ini
HF_AUTH_TOKEN = "hf_<YourToken>"
ONLINE = True
SSL_CERTFILE = "ssl/cert.pem"
SSL_KEYFILE = "ssl/key.pem"
ROOT = ""
WINDOWS = False
DEVICE = "cuda"
ADDITIONAL_SPEAKERS = 4
STORAGE_SECRET = "<ExampleSecret>"
BATCH_SIZE = 16
```

**Explanation:**

| Argument            | Description                                                                   |
| ------------------- | ----------------------------------------------------------------------------- |
| ONLINE              | `Boolean` - `True` Exposes the Frontend to the Network                        |
| SSL_CERTFILE        | ` String` - The File Path to the SSL cert file                                |
| SSL_KEYFILE         | ` String` - The File Path to the SSL key file                                 |
| STORAGE_SECRET      | ` String` - Secret key for cookie-based identification of users               |
| ROOT                | ` String` - File Path to `main.py` and `worker.py`                            |
| WINDOWS             | `Boolean` - Set `True` if you are running this app on Windows.                |
| DEVICE              | ` String` - `cuda` For CUDA-GPU, `cpu` For CPU.                               |
| ADDITIONAL_SPEAKERS | `Integer` - Number of additional speakers provied in the editor               |
| BATCH_SIZE          | `Integer` - Whisper inference Batch size. `4` w/ 8GB VRAM, `32` w/ 16GB VRAM. |


### 01.05 - Building the Image

The Original Repository Offers 2 Ways to Build the Image:

* From machinelearningZH
  * Dockerfile: [docker/mlzh.Dockerfile](./docker/mlzh.Dockerfile)
  * Docker Compose: [docker/mlzh.docker-compose.yml](./docker/mlzh.docker-compose.yml)
  * Start Script: [docker/mlzh.startup.sh](./docker/mlzh.startup.sh)
* From Canton Aargau
  * Dockerfile: [docker/aargau.Dockerfile](./docker/aargau.Dockerfile)
  * Docker Compose: [docker/aargau.docker-compose.yml](./docker/aargau.docker-compose.yml)
  * Start Script: [docker/aargau.startup.sh](./docker/aargau.bootup.sh)

To use either of those Configurations, move the relevant Files into the Repository Root,
and Remove the `aargau.` or `mlzh.` Prefix from the Filename.

The Dockerfile and Docker Compose File are Modified Versions of the original Files from machinelearningZH.
To build the Image, run this command in the Repository Root:

```bash
docker build -t transcribo:latest .
```

The Resulting Image will be relatively Big (~17 GB), so the Process will take between 5 - 7 Minutes.


### 01.06 - Starting the Server

To Start The Server Run either One of these Commands:

**Using `Docker Compose`**

```bash
docker compose up -d
```

**Using `Docker run`**

```bash
docker run --name transcribo \
           --detach \
           --restart unless-stopped \
           -p 8080:8080 \
           -v $(pwd)/input_directory:/app/data/in \
           -v $(pwd)/output_directory:/app/data/out \
           -v $(pwd)/hf_cache:/root/.cache/huggingface \
           --gpus 1 \ 
           transcribo:latest
```

The Logs can be accessed using:

```bash
docker logs -f transcribo
```

---


02 - Project Information
---

This application provides advanced transcription capabilities for confidential audio and video files using the state-of-the-art Whisper v3 large model (non-quantized). It offers top-tier transcription quality without licensing or usage fees, even for Swiss German.

### 02.01 - What does the application do?
- State-of-the-Art Transcription: Powered by Whisper v3 large model, ensuring high accuracy and reliability.
- Cost-Free: No license or usage-related costs, making it an affordable solution for everyone.
- High Performance: Transcribe up to 15 times faster than real-time, ensuring efficient processing.
- High-Quality Transcriptions: Exceptional transcription quality for English and local languages, with substantial accuracy for Swiss German.
- Speaker Diarisation: Automatic identification and differentiation of speakers within the audio.
- Multi-File Upload: Easily upload and manage multiple files for transcription.
- Predefined vocabulary: Define the spelling of ambiguous words and names.
- Transcript Export Options: Export transcriptions in various formats:
    - Text file
    - SRT file (for video subtitles)
    - Synchronized viewer with integrated audio or video
- Integrated Editing: Edit transcriptions directly within the application, synchronously linked with the source video or audio. The editor is open-source and requires no installation.
    - General Text Editing Functions: Standard text editing features for ease of use.
    - Segments: Add or remove speech segments.
    - Speaker Naming: Assign names to identified speakers for clarity.
    - Power User Shortcuts: Keyboard shortcuts for enhanced navigation and control (start, stop, forward, backward, etc.).

---


03 - Project team
---

This project is a collaborative effort of these people of the cantonal administration of Zurich:

- **Stephan Walder** - [Leiter Digitale Transformation, Oberstaatsanwaltschaft Kanton Zürich](https://www.zh.ch/de/direktion-der-justiz-und-des-innern/staatsanwaltschaft/Oberstaatsanwaltschaft-des-Kantons-Zuerich.html)
- **Dominik Frefel** - [Team Data, Statistisches Amt](https://www.zh.ch/de/direktion-der-justiz-und-des-innern/statistisches-amt/data.html)
- **Patrick Arnecke** - [Team Data, Statistisches Amt](https://www.zh.ch/de/direktion-der-justiz-und-des-innern/statistisches-amt/data.html)

---


04 - Feedback and Contributions
---

Please share your feedback and let us know how you use the app in your institution. 
You can [write an email](mailto:datashop@statistik.zh.ch) or share your ideas by opening an issue or a pull requests.

Please note, we use [Ruff](https://docs.astral.sh/ruff/) for linting and code formatting with default settings.

---


05 - Disclaimer
---

This transcription software (the Software) incorporates the open-source model 
Whisper Large v3 (the Model) and has been developed according to and with the 
intent to be used under Swiss law. Please be aware that the 
EU Artificial Intelligence Act (EU AI Act) may, under certain circumstances, 
be applicable to your use of the Software. You are solely responsible for ensuring 
that your use of the Software as well as of the underlying Model complies with 
all applicable local, national and international laws and regulations. 
By using this Software, you acknowledge and agree (a) that it is your 
responsibility to assess which laws and regulations, in particular regarding 
the use of AI technologies, are applicable to your intended use and to comply 
therewith, and (b) that you will hold us harmless from any action, claims, 
liability or loss in respect of your use of the Software.
