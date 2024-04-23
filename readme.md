# Project Name: Mistral SQL Query Validator

### Description:

- This project provides a user-friendly interface for interacting with both online and offline language models through a Gradio app.

### Prerequisites:

- Ensure you have Python 3.x and pip installed on your system. You can verify this by running the following commands in your terminal:
```Bash

python3 --version
pip --version
```

If you don't have them, you can download and install Python from https://www.python.org/downloads/.

### Install dependencies:

Navigate to your project directory in the terminal.
Run the following command to install the required libraries:
```Bash
pip install requirements.txt
```
## Usage:

### Online Model:

#### Start the server:
Open your terminal and navigate to the project directory.
Run the following command:
```Bash
python new_gradio_gpt.py
```
This will start the Gradio app using the online GPT model.

#### Access the app:
A link to the Gradio app will be printed in the terminal. Open this link in your web browser, typically http://127.0.0.1:7860/.
You can now interact with the online model using the provided interface.
### Offline Model:

#### Start the server:
Open your terminal and navigate to the project directory.
Run the following command:
```Bash
python new_gradio_mistral.py
```
This will start the Gradio app using the offline Mistral model.
#### Access the app:
A link to the Gradio app will be printed in the terminal. Open this link in your web browser, typically http://127.0.0.1:7860/.
You can now interact with the offline model using the provided interface.
## Note:

Additional Considerations:

If you encounter any errors during installation or usage, refer to the documentation for Gradio, Mistral, and transformers for troubleshooting steps.
